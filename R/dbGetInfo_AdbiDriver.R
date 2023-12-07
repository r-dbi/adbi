#' @rdname AdbiDriver-class
#' @inheritParams DBI::dbGetInfo
#' @usage NULL
dbGetInfo_AdbiDriver <- function(dbObj, ...) {
  testthat::skip("Not yet implemented: dbGetInfo(Driver)")
}

#' @rdname AdbiDriver-class
#' @export
setMethod("dbGetInfo", "AdbiDriver", dbGetInfo_AdbiDriver)
