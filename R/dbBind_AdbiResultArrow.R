#' @rdname AdbiResultArrow-class
#' @inheritParams DBI::dbBind
#' @usage NULL
dbBind_AdbiResultArrow <- function(res, params, ...) {
  dbBind_AdbiResult(res, params, ...)
}

#' @rdname AdbiResultArrow-class
#' @export
setMethod("dbBind", "AdbiResultArrow", dbBind_AdbiResultArrow)
