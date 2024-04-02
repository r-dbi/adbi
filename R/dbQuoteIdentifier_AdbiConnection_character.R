#' @rdname AdbiConnection-class
#' @inheritParams DBI::dbQuoteIdentifier
#' @usage NULL
dbQuoteIdentifier_AdbiConnection_character <- function(conn, x, ...) {
  dbQuoteIdentifier(ANSI(), x, ...)
}

#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbQuoteIdentifier",
  c("AdbiConnection", "character"),
  dbQuoteIdentifier_AdbiConnection_character
)

#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbQuoteIdentifier",
  c("AdbiConnection", "SQL"),
  dbQuoteIdentifier_AdbiConnection_character
)
