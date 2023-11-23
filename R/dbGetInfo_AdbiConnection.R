#' @rdname DBI
#' @inheritParams DBI::dbGetInfo
#' @usage NULL
dbGetInfo_AdbiConnection <- function(dbObj, ...) {
  testthat::skip("Not yet implemented: dbGetInfo(Connection)")
}
#' @rdname DBI
#' @export
setMethod("dbGetInfo", "AdbiConnection", dbGetInfo_AdbiConnection)
