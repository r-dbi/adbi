#' @rdname AdbiResultArrow-class
#' @param res An object inheriting from [DBI::DBIResult][DBI::DBIResult-class].
#' @inheritParams DBI::dbClearResult
#' @usage NULL
dbClearResult_AdbiResultArrow <- function(res, ...) {
  dbClearResult_AdbiResult(res)
}

#' @rdname AdbiResultArrow-class
#' @export
setMethod("dbClearResult", "AdbiResultArrow", dbClearResult_AdbiResultArrow)
