#' @rdname AdbiConnection-class
#' @inheritParams DBI::dbQuoteString
#' @usage NULL
dbQuoteString_AdbiConnection_character <- function(conn, x, ...) {
  dbQuoteString(ANSI(), x, ...)
}

#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbQuoteString",
  c("AdbiConnection", "character"),
  dbQuoteString_AdbiConnection_character
)

#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbQuoteString",
  c("AdbiConnection", "SQL"),
  dbQuoteString_AdbiConnection_character
)
