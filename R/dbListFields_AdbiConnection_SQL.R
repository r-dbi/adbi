#' @rdname DBI
#' @inheritParams DBI::dbListFields
#' @usage NULL
dbListFields_AdbiConnection_SQL <- function(conn, name, ...) {
  dbListFields(conn, dbUnquoteIdentifier(conn, name)[[1L]], ...)
}

#' @rdname DBI
#' @export
setMethod(
  "dbListFields",
  c("AdbiConnection", "SQL"),
  dbListFields_AdbiConnection_SQL
)
