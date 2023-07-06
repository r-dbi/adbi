#' @rdname DBI
#' @inheritParams DBI::dbGetInfo
#' @usage NULL
dbGetInfo_KazamConnection <- function(dbObj, ...) {
  testthat::skip("Not yet implemented: dbGetInfo(Connection)")
}
#' @rdname DBI
#' @export
setMethod("dbGetInfo", "KazamConnection", dbGetInfo_KazamConnection)
