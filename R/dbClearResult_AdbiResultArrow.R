#' @rdname AdbiResultArrow-class
#' @inheritParams DBI::dbClearResult
#' @usage NULL
dbClearResult_AdbiResultArrow <- function(res, ...) {
  dbClearResult_AdbiResult(res)
}

#' @rdname AdbiResultArrow-class
#' @export
setMethod("dbClearResult", "AdbiResultArrow", dbClearResult_AdbiResultArrow)
