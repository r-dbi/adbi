#' @rdname DBI
#' @inheritParams DBI::dbGetRowsAffected
#' @usage NULL
dbGetRowsAffected_AdbiResult <- function(res, ...) {
  testthat::skip("Not yet implemented: dbGetRowsAffected(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbGetRowsAffected", "AdbiResult", dbGetRowsAffected_AdbiResult)
