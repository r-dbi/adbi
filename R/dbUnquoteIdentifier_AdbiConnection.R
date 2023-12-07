#' @rdname AdbiConnection-class
#' @inheritParams DBI::dbUnquoteIdentifier
#' @usage NULL
dbUnquoteIdentifier_AdbiConnection <- function(conn, x, ...) {
  dbUnquoteIdentifier(ANSI(), x, ...)
}

#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbUnquoteIdentifier",
  "AdbiConnection",
  dbUnquoteIdentifier_AdbiConnection
)
