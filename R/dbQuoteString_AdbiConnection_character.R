#' @rdname DBI
#' @inheritParams DBI::dbQuoteString
#' @usage NULL
dbQuoteString_AdbiConnection_character <- function(conn, x, ...) {
  dbQuoteString(ANSI(), x, ...)
}

#' @rdname DBI
#' @export
setMethod(
  "dbQuoteString",
  c("AdbiConnection", "character"),
  dbQuoteString_AdbiConnection_character
)
