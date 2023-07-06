#' @rdname DBI
#' @inheritParams DBI::dbFetch
#' @usage NULL
dbFetchArrow_KazamResultArrow <- function(res, ...) {
  # TODO: Implement as needed, or remove (default DBI implementation exists)
  testthat::skip("Not yet implemented: dbFetchArrow(ResultArrow)")
}
#' @rdname DBI
#' @export
setMethod("dbFetchArrow", "KazamResultArrow", dbFetchArrow_KazamResultArrow)
