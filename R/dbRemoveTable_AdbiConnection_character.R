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

  if (temporary) {
    schema <- db_temp_schema(conn@connection$database$driver, conn@connection)
    name <- paste0(schema, ".", name)
  }

  sql <- paste0(
    "DROP TABLE ",
    if (!fail_if_missing) "IF EXISTS ",
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
