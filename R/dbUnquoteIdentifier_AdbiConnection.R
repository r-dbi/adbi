#' @rdname DBI
#' @inheritParams DBI::dbUnquoteIdentifier
#' @usage NULL
dbUnquoteIdentifier_AdbiConnection <- function(conn, x, ...) {
  dbUnquoteIdentifier(ANSI(), x, ...)
}

#' @rdname DBI
#' @export
setMethod(
  "dbUnquoteIdentifier",
  "AdbiConnection",
  dbUnquoteIdentifier_AdbiConnection
)
