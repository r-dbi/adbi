#' @rdname DBI
#' @inheritParams DBI::dbExistsTable
#' @usage NULL
dbExistsTable_AdbiConnection_character <- function(conn, name, ...) {
  name %in% dbListTables(conn)
}

#' @rdname DBI
#' @export
setMethod(
  "dbExistsTable",
  c("AdbiConnection", "character"),
  dbExistsTable_AdbiConnection_character
)
