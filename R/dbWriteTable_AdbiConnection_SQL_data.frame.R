#' @rdname DBI
#' @inheritParams DBI::dbWriteTable
#' @usage NULL
dbWriteTable_AdbiConnection_SQL_data.frame <- function(conn, name, value, ...) {
  dbWriteTable(conn, dbUnquoteIdentifier(conn, name)[[1L]], value, ...)
}

#' @rdname DBI
#' @export
setMethod(
  "dbWriteTable",
  c("AdbiConnection", "SQL", "data.frame"),
  dbWriteTable_AdbiConnection_SQL_data.frame
)
