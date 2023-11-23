#' @rdname DBI
#' @inheritParams DBI::dbListTables
#' @usage NULL
dbListTables_AdbiConnection <- function(conn, ...) {

  if (!dbIsValid(conn)) {
    stop("Invalid connection.", call. = FALSE)
  }

  get_schema_objects(conn, "table")[["table_name"]]
}

#' @rdname DBI
#' @export
setMethod("dbListTables", "AdbiConnection", dbListTables_AdbiConnection)

process_fields <- function(x, dat, what) {

  stopifnot(identical(what, "field"))

  res <- x[, c("column_name", "xdbc_type_name")]

  if (!nrow(res)) {
    dat <- dat[0L, , drop = FALSE]
  }

  cbind(dat, res, row.names = NULL)
}

process_tables <- function(x, dat, what) {

  res <- x[, c("table_name", "table_type")]

  if (!nrow(res)) {
    dat <- dat[0L, , drop = FALSE]
  }

  res <- cbind(dat, res, row.names = NULL)

  if (identical(what, "table")) {
    return(res)
  }

  res <- Map(
    process_fields,
    x[["table_columns"]],
    split_rows(res),
    MoreArgs = list(what = what)
  )

  do.call(rbind, res)
}

process_schemas <- function(x, dat, what) {

  res <- x[, c("db_schema_name"), drop = FALSE]

  if (!nrow(res)) {
    dat <- dat[0L, , drop = FALSE]
  }

  res <- cbind(dat, res, row.names = NULL)

  if (identical(what, "schema")) {
    return(res)
  }

  res <- Map(
    process_tables,
    x[["db_schema_tables"]],
    split_rows(res),
    MoreArgs = list(what = what)
  )

  do.call(rbind, res)
}

process_catalogs <- function(x, what) {

  res <- x[, c("catalog_name"), drop = FALSE]

  if (identical(what, "catalog")) {
    return(res)
  }

  res <- Map(
    process_schemas,
    x[["catalog_db_schemas"]],
    split_rows(res),
    MoreArgs = list(what = what)
  )

  do.call(rbind, res)
}

get_schema_objects <- function(con,
    what = c("catalog", "schema", "table", "field"),
    catalog = NULL,
    schema = NULL,
    table = NULL) {

  what <- match.arg(what)

  nfo <- adbcdrivermanager::adbc_connection_get_objects(
    con@connection,
    depth = switch(what, catalog = 1L, schema = 2L, table = 3L, field = 0L),
    catalog = catalog,
    db_schema = schema,
    table_name = table
  )

  process_catalogs(
    nanoarrow::convert_array_stream(nfo),
    what
  )
}
