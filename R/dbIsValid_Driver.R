#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_AdbiDriver <- function(dbObj, ...) {
  testthat::skip("Not yet implemented: dbIsValid(Driver)")
}
#' @rdname DBI
#' @export
setMethod("dbIsValid", "AdbiDriver", dbIsValid_AdbiDriver)
