#' @rdname AdbiResultArrow-class
#' @inheritParams DBI::dbColumnInfo
#' @usage NULL
dbColumnInfo_AdbiResultArrow <- function(res, ...) {
  dbColumnInfo_AdbiResult(res, ...)
}

#' @rdname AdbiResultArrow-class
#' @export
setMethod("dbColumnInfo", "AdbiResultArrow", dbColumnInfo_AdbiResultArrow)
