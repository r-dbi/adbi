#' @rdname AdbiConnection-class
#' @param fail_if_missing If `FALSE`, [DBI::dbRemoveTable()] succeeds if the
#'   table doesn't exist.
#' @inheritParams DBI::dbRemoveTable
#' @usage NULL
dbRemoveTable_AdbiConnection <- function(
  conn,
  name,
  ...,
  temporary = FALSE,
  fail_if_missing = TRUE
) {
  name <- dbQuoteIdentifier(conn, name)

  schema <- if (temporary) {
    db_temp_schema(conn@connection$database$driver, conn@connection)
  }

  sql <- paste0(
    "DROP ",
    if (temporary && is.null(schema)) "TEMPORARY ",
    "TABLE ",
    if (!fail_if_missing) "IF EXISTS ",
    if (!is.null(schema)) paste0(schema, "."),
    name
  )

  dbExecute(conn, sql)

  invisible(TRUE)
}

#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbRemoveTable",
  c("AdbiConnection", "character"),
  dbRemoveTable_AdbiConnection
)
