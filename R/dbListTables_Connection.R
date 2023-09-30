#' @rdname DBI
#' @inheritParams DBI::dbListTables
#' @usage NULL
dbListTables_AdbiConnection <- function(conn, ...) {

  extract_tables <- function(x) {
    x[, c("table_name", "table_type")]
  }

  extract_schemas <- function(x) {
    cbind(
      schema_name = x[["db_schema_name"]],
      do.call(rbind, lapply(x[["db_schema_tables"]], extract_tables))
    )
  }

  extract_catalogs <- function(x) {
    cbind(
      catalog_name = x[["catalog_name"]],
      do.call(rbind, lapply(x[["catalog_db_schemas"]], extract_schemas))
    )
  }

  stopifnot(dbIsValid(conn))

  res <- adbcdrivermanager::adbc_connection_get_objects(
    conn@connection,
    depth = 3L
  )

  tbl <- extract_catalogs(
    nanoarrow::convert_array_stream(res)
  )

  tbl[["table_name"]]
}

#' @rdname DBI
#' @export
setMethod("dbListTables", "AdbiConnection", dbListTables_AdbiConnection)
