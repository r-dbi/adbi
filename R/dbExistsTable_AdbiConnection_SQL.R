#' @rdname AdbiConnection-class
#' @inheritParams DBI::dbExistsTable
#' @usage NULL
dbExistsTable_AdbiConnection_SQL <- function(conn, name, ...) {
  dbExistsTable(conn, dbUnquoteIdentifier(conn, name)[[1L]], ...)
}

#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbExistsTable",
  c("AdbiConnection", "SQL"),
  dbExistsTable_AdbiConnection_SQL
)
