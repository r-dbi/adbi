#' @rdname AdbiResultArrow-class
#' @inheritParams DBI::dbBindArrow
#' @usage NULL
dbBindArrow_AdbiResultArrow <- function(res, params, ...) {
  dbBindArrow_AdbiResult(res, params, ...)
}

#' @rdname AdbiResultArrow-class
#' @export
setMethod("dbBindArrow", "AdbiResultArrow", dbBindArrow_AdbiResultArrow)
