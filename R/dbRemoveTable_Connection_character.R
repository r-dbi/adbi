#' @rdname DBI
#' @param fail_if_missing If `FALSE`, `dbRemoveTable()` succeeds if the
#'   table doesn't exist.
#' @inheritParams DBI::dbRemoveTable
#' @usage NULL
dbRemoveTable_KazamConnection_character <- function(conn, name, ...,
                                                    temporary = FALSE,
                                                    fail_if_missing = TRUE) {
  name <- dbQuoteIdentifier(conn, name)

  sql <- paste0(
    "DROP ",
    if (temporary) "TEMPORARY ",
    "TABLE ",
    if (!fail_if_missing) "IF EXISTS ",
    name
  )

  dbExecute(conn, sql)

  invisible(TRUE)
}
#' @rdname DBI
#' @export
setMethod("dbRemoveTable", c("KazamConnection", "character"), dbRemoveTable_KazamConnection_character)
