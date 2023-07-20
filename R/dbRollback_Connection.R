#' @rdname DBI
#' @inheritParams DBI::dbRollback
#' @usage NULL
dbRollback_AdbiConnection <- function(conn, ...) {
  testthat::skip("Not yet implemented: dbRollback(Connection)")
}
#' @rdname DBI
#' @export
setMethod("dbRollback", "AdbiConnection", dbRollback_AdbiConnection)
