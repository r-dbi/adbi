#' @rdname DBI
#' @inheritParams DBI::dbFetch
#' @usage NULL
dbFetchArrow_AdbiResultArrow <- function(res, ...) {
  # TODO: Implement as needed, or remove (default DBI implementation exists)
  testthat::skip("Not yet implemented: dbFetchArrow(ResultArrow)")
}
#' @rdname DBI
#' @export
setMethod("dbFetchArrow", "AdbiResultArrow", dbFetchArrow_AdbiResultArrow)
