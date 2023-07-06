#' @rdname DBI
#' @inheritParams DBI::dbGetRowsAffected
#' @usage NULL
dbGetRowsAffected_KazamResult <- function(res, ...) {
  testthat::skip("Not yet implemented: dbGetRowsAffected(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbGetRowsAffected", "KazamResult", dbGetRowsAffected_KazamResult)
