#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_AdbiResultArrow <- function(dbObj, ...) {
  dbIsValid_AdbiResult(dbObj, ...)
}
#' @rdname DBI
#' @export
setMethod("dbIsValid", "AdbiResultArrow", dbIsValid_AdbiResultArrow)
