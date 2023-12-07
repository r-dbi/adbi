#' @rdname AdbiConnection-class
#' @inheritParams DBI::dbGetInfo
#' @usage NULL
dbGetInfo_AdbiConnection <- function(dbObj, ...) {
  testthat::skip("Not yet implemented: dbGetInfo(Connection)")
}

#' @rdname AdbiConnection-class
#' @export
setMethod("dbGetInfo", "AdbiConnection", dbGetInfo_AdbiConnection)
