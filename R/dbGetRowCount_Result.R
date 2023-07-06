#' @rdname DBI
#' @inheritParams DBI::dbGetRowCount
#' @usage NULL
dbGetRowCount_KazamResult <- function(res, ...) {
  testthat::skip("Not yet implemented: dbGetRowCount(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbGetRowCount", "KazamResult", dbGetRowCount_KazamResult)
