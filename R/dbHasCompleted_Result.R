#' @rdname DBI
#' @inheritParams DBI::dbHasCompleted
#' @usage NULL
dbHasCompleted_AdbiResult <- function(res, ...) {
  testthat::skip("Not yet implemented: dbHasCompleted(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbHasCompleted", "AdbiResult", dbHasCompleted_AdbiResult)
