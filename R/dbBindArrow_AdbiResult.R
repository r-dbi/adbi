#' @rdname AdbiResult-class
#' @inheritParams DBI::dbBindArrow
#' @usage NULL
dbBindArrow_AdbiResult <- function(res, params, ...) {
  # FIXME: avoid coercing params to data.frame,
  # dbBind_AdbiResult should call this function instead

  dbBind_AdbiResult(res, as.data.frame(params), ...)
}

#' @rdname AdbiResult-class
#' @export
setMethod("dbBindArrow", "AdbiResult", dbBindArrow_AdbiResult)
