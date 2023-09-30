#' @rdname DBI
#' @inheritParams DBI::dbQuoteIdentifier
#' @usage NULL
dbQuoteIdentifier_AdbiConnection_character <- function(conn, x, ...) {
  dbQuoteIdentifier(ANSI(), x, ...)
}

#' @rdname DBI
#' @export
setMethod(
  "dbQuoteIdentifier",
  c("AdbiConnection", "character"),
  dbQuoteIdentifier_AdbiConnection_character
)
