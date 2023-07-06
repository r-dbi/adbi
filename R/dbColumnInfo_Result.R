#' @rdname DBI
#' @inheritParams DBI::dbColumnInfo
#' @usage NULL
dbColumnInfo_KazamResult <- function(res, ...) {
  testthat::skip("Not yet implemented: dbColumnInfo(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbColumnInfo", "KazamResult", dbColumnInfo_KazamResult)
