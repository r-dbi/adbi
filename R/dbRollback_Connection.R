#' @rdname DBI
#' @inheritParams DBI::dbRollback
#' @usage NULL
dbRollback_KazamConnection <- function(conn, ...) {
  testthat::skip("Not yet implemented: dbRollback(Connection)")
}
#' @rdname DBI
#' @export
setMethod("dbRollback", "KazamConnection", dbRollback_KazamConnection)
