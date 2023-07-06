#' @rdname DBI
#' @inheritParams DBI::dbCommit
#' @usage NULL
dbCommit_KazamConnection <- function(conn, ...) {
  testthat::skip("Not yet implemented: dbCommit(Connection)")
}
#' @rdname DBI
#' @export
setMethod("dbCommit", "KazamConnection", dbCommit_KazamConnection)
