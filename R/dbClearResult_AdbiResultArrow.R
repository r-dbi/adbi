#' @rdname DBI
#' @inheritParams DBI::dbClearResult
#' @usage NULL
dbClearResult_AdbiResultArrow <- function(res, ...) {
  # TODO: Implement as needed, or remove (default DBI implementation exists)
  dbClearResult_AdbiResult(res)
}
#' @rdname DBI
#' @export
setMethod("dbClearResult", "AdbiResultArrow", dbClearResult_AdbiResultArrow)
