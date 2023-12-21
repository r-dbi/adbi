#' @rdname AdbiResultArrow-class
#' @inheritParams DBI::dbGetRowCount
#' @usage NULL
dbGetRowCount_AdbiResultArrow <- function(res, ...) {
  dbGetRowCount_AdbiResult(res, ...)
}

#' @rdname AdbiResultArrow-class
#' @export
setMethod("dbGetRowCount", "AdbiResultArrow", dbGetRowCount_AdbiResultArrow)
