#' @rdname DBI
#' @inheritParams DBI::dbGetInfo
#' @usage NULL
dbGetInfo_KazamDriver <- function(dbObj, ...) {
  testthat::skip("Not yet implemented: dbGetInfo(Driver)")
}
#' @rdname DBI
#' @export
setMethod("dbGetInfo", "KazamDriver", dbGetInfo_KazamDriver)
