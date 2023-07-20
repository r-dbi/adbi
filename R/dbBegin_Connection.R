#' @rdname DBI
#' @inheritParams DBI::dbBegin
#' @usage NULL
dbBegin_AdbiConnection <- function(conn, ...) {
  testthat::skip("Not yet implemented: dbBegin(Connection)")
}
#' @rdname DBI
#' @export
setMethod("dbBegin", "AdbiConnection", dbBegin_AdbiConnection)
