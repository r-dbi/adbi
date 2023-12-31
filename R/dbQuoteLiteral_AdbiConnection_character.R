#' @rdname AdbiConnection-class
#' @inheritParams DBI::dbQuoteLiteral
#' @usage NULL
dbQuoteLiteral_AdbiConnection_character <- function(conn, x, ...) {
  dbQuoteLiteral(ANSI(), x, ...)
}

#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbQuoteLiteral",
  c("AdbiConnection", "character"),
  dbQuoteLiteral_AdbiConnection_character
)
