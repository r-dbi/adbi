#' @rdname DBI
#' @inheritParams DBI::dbExistsTable
#' @usage NULL
dbExistsTable_AdbiConnection_character <- function(conn, name, ...) {
  dbExistsTable(conn, Id(table = name), ...)
}

#' @rdname DBI
#' @export
setMethod(
  "dbExistsTable",
  c("AdbiConnection", "character"),
  dbExistsTable_AdbiConnection_character
)
