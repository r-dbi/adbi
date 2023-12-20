#' @rdname DBI
#' @inheritParams DBI::dbBind
#' @usage NULL
dbBind_AdbiResultArrow <- function(res, params, ...) {
  dbBind_AdbiResult(res, params, ...)
}
#' @rdname DBI
#' @export
setMethod("dbBind", "AdbiResultArrow", dbBind_AdbiResultArrow)
