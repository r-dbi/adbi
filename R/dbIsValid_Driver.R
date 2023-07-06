#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_KazamDriver <- function(dbObj, ...) {
  testthat::skip("Not yet implemented: dbIsValid(Driver)")
}
#' @rdname DBI
#' @export
setMethod("dbIsValid", "KazamDriver", dbIsValid_KazamDriver)
