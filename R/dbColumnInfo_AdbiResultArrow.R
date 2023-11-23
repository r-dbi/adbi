#' @rdname DBI
#' @inheritParams DBI::dbColumnInfo
#' @usage NULL
dbColumnInfo_AdbiResultArrow <- function(res, ...) {
  dbColumnInfo_AdbiResult(res, ...)
}

#' @rdname DBI
#' @export
setMethod("dbColumnInfo", "AdbiResultArrow", dbColumnInfo_AdbiResultArrow)
