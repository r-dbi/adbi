#' @rdname DBI
#' @inheritParams DBI::dbBegin
#' @usage NULL
dbBegin_KazamConnection <- function(conn, ...) {
  testthat::skip("Not yet implemented: dbBegin(Connection)")
}
#' @rdname DBI
#' @export
setMethod("dbBegin", "KazamConnection", dbBegin_KazamConnection)
