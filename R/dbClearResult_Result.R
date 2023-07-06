#' @rdname DBI
#' @inheritParams DBI::dbClearResult
#' @usage NULL
dbClearResult_KazamResult <- function(res, ...) {
  testthat::skip("Not yet implemented: dbClearResult(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbClearResult", "KazamResult", dbClearResult_KazamResult)
