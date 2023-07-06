#' @rdname DBI
#' @inheritParams DBI::dbQuoteString
#' @usage NULL
dbQuoteString_KazamConnection_character <- function(conn, x, ...) {
  # Optional
  getMethod("dbQuoteString", c("DBIConnection", "character"), asNamespace("DBI"))(conn, x, ...)
}
#' @rdname DBI
#' @export
setMethod("dbQuoteString", c("KazamConnection", "character"), dbQuoteString_KazamConnection_character)
