#' @rdname AdbiConnection-class
#' @inheritParams DBI::dbWriteTable
#' @param overwrite Allow overwriting the destination table. Cannot be
#'   `TRUE` if `append` is also `TRUE`.
#' @param append Allow appending to the destination table. Cannot be
#'   `TRUE` if `overwrite` is also `TRUE`.
#' @param field.types character vector of named SQL field types where
#'   the names are the names of new table's columns. If missing, types inferred
#'   with [DBI::dbDataType()]).
#' @param row.names A logical specifying whether the `row.names` should be
#'   output to the output DBMS table; if `TRUE`, an extra field whose name
#'   will be whatever the R identifier `"row.names"` maps to the DBMS (see
#'   [DBI::make.db.names()]). If `NA` will add rows names if
#'   they are characters, otherwise will ignore.
#' @param temporary a logical specifying whether the new table should be
#'   temporary. Its default is `FALSE`.
#' @usage NULL
dbWriteTable_AdbiConnection_Id_data.frame <- function(conn, name, value,
    overwrite = FALSE, append = FALSE, ..., field.types = NULL,
    row.names = NULL, temporary = FALSE) {

  if (!dbIsValid(conn)) {
    stop("Invalid connection.", call. = FALSE)
  }

  if (is.null(row.names)) {
    row.names <- FALSE
  }

  if ((!is.logical(row.names) && !is.character(row.names)) ||
    length(row.names) != 1L) {

    stop(
      "Argument `row.names` must be a logical scalar or a string",
      call. = FALSE
    )
  }

  if (!is.logical(overwrite) || length(overwrite) != 1L || is.na(overwrite)) {
    stop("Argument `overwrite` must be a logical scalar", call. = FALSE)
  }

  if (!is.logical(append) || length(append) != 1L || is.na(append)) {
    stop("Argument `append` must be a logical scalar", call. = FALSE)
  }

  if (!is.logical(temporary) || length(temporary) != 1L) {
    stop("Argument `temporary` must be a logical scalar", call. = FALSE)
  }

  if (overwrite && append) {
    stop(
      "Arguments `overwrite` and `append` cannot both be TRUE",
      call. = FALSE
    )
  }

  if (!is.null(field.types)) {
    stop("Specifying field.types is not supported", call. = FALSE)
  }

  catalog <- NULL
  schema <- NULL

  table <- name@name

  if (all(names(table) == "")) {
    names(table) <- NULL
  }

  if (!all(names(table) %in% c("catalog", "schema", "table"))) {
    stop(
      "Expecting Id components \"catalog\", \"schema\", and \"table\", ",
      "not ", paste0("\"", names(table), "\"", collapse = ", "), ".",
      call. = FALSE
    )
  }

  if ("catalog" %in% names(table)) {
    catalog <- unname(table["catalog"])
  }

  if ("schema" %in% names(table)) {
    schema <- unname(table["schema"])
  }

  if ("table" %in% names(table)) {
    table <- unname(table["table"])
  }

  if (!is.character(table) && length(table) == 1L && is.null(names(table))) {
    stop("Expecting an unnamed string as table name", call. = FALSE)
  }

  if (append) {
    mode <- "append"
  } else if (overwrite) {
    # TODO: use "replace" mode when available: apache/arrow-adbc#1355
    # mode <- "replace"
    dbRemoveTable(conn, name, temporary = temporary, fail_if_missing = FALSE)
  } else {
    mode <- "create"
  }

  stmt <- adbcdrivermanager::adbc_statement_init(
    conn@connection,
    adbc.ingest.target_table = table,
    adbc.ingest.target_catalog = catalog,
    adbc.ingest.target_db_schema = schema,
    adbc.ingest.mode = paste0("adbc.ingest.mode.", mode),
    adbc.ingest.temporary = if (temporary) "true"
  )

  on.exit(adbcdrivermanager::adbc_statement_release(stmt))

  value <- sqlRownamesToColumn(value, row.names)

  adbcdrivermanager::adbc_statement_bind_stream(stmt, value)
  adbcdrivermanager::adbc_statement_execute_query(stmt)

  invisible(TRUE)
}

#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbWriteTable",
  c("AdbiConnection", "Id", "data.frame"),
  dbWriteTable_AdbiConnection_Id_data.frame
)
