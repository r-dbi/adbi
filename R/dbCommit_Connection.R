#' @rdname DBI
#' @inheritParams DBI::dbCommit
#' @usage NULL
dbCommit_AdbiConnection <- function(conn, ...) {
  testthat::skip("Not yet implemented: dbCommit(Connection)")
}
#' @rdname DBI
#' @export
setMethod("dbCommit", "AdbiConnection", dbCommit_AdbiConnection)
