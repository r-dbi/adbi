#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_KazamResult <- function(dbObj, ...) {
  testthat::skip("Not yet implemented: dbIsValid(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbIsValid", "KazamResult", dbIsValid_KazamResult)
