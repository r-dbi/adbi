#' @rdname DBI
#' @inheritParams DBI::dbHasCompleted
#' @usage NULL
dbHasCompleted_KazamResult <- function(res, ...) {
  testthat::skip("Not yet implemented: dbHasCompleted(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbHasCompleted", "KazamResult", dbHasCompleted_KazamResult)
