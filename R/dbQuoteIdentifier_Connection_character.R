#' @rdname DBI
#' @inheritParams DBI::dbQuoteIdentifier
#' @usage NULL
dbQuoteIdentifier_KazamConnection_character <- function(conn, x, ...) {
  # Optional
  getMethod("dbQuoteIdentifier", c("DBIConnection", "character"), asNamespace("DBI"))(conn, x, ...)
}
#' @rdname DBI
#' @export
setMethod("dbQuoteIdentifier", c("KazamConnection", "character"), dbQuoteIdentifier_KazamConnection_character)
