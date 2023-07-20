#' @rdname DBI
#' @inheritParams DBI::dbQuoteIdentifier
#' @usage NULL
dbQuoteIdentifier_AdbiConnection_character <- function(conn, x, ...) {
  # Optional
  getMethod("dbQuoteIdentifier", c("DBIConnection", "character"), asNamespace("DBI"))(conn, x, ...)
}
#' @rdname DBI
#' @export
setMethod("dbQuoteIdentifier", c("AdbiConnection", "character"), dbQuoteIdentifier_AdbiConnection_character)
