#' @rdname DBI
#' @inheritParams DBI::dbColumnInfo
#' @usage NULL
dbColumnInfo_AdbiResult <- function(res, ...) {
  testthat::skip("Not yet implemented: dbColumnInfo(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbColumnInfo", "AdbiResult", dbColumnInfo_AdbiResult)
