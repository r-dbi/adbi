#' @rdname DBI
#' @inheritParams DBI::dbGetRowCount
#' @usage NULL
dbGetRowCount_AdbiResultArrow <- function(res, ...) {
  dbGetRowCount_AdbiResult(res, ...)
}

#' @rdname DBI
#' @export
setMethod("dbGetRowCount", "AdbiResultArrow", dbGetRowCount_AdbiResultArrow)
