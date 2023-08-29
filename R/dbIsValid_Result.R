#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_AdbiResult <- function(dbObj, ...) {
  testthat::skip("Not yet implemented: dbIsValid(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbIsValid", "AdbiResult", dbIsValid_AdbiResult)
