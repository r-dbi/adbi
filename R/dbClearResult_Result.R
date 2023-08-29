#' @rdname DBI
#' @inheritParams DBI::dbClearResult
#' @usage NULL
dbClearResult_AdbiResult <- function(res, ...) {
  testthat::skip("Not yet implemented: dbClearResult(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbClearResult", "AdbiResult", dbClearResult_AdbiResult)
