#' @rdname DBI
#' @inheritParams DBI::dbGetInfo
#' @usage NULL
dbGetInfo_AdbiDriver <- function(dbObj, ...) {
  testthat::skip("Not yet implemented: dbGetInfo(Driver)")
}
#' @rdname DBI
#' @export
setMethod("dbGetInfo", "AdbiDriver", dbGetInfo_AdbiDriver)
