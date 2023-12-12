#' @rdname AdbiResultArrow-class
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_AdbiResultArrow <- function(dbObj, ...) {
  dbIsValid_AdbiResult(dbObj, ...)
}

#' @rdname AdbiResultArrow-class
#' @export
setMethod("dbIsValid", "AdbiResultArrow", dbIsValid_AdbiResultArrow)
