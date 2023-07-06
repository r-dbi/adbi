#' @rdname DBI
#' @inheritParams DBI::dbClearResult
#' @usage NULL
dbClearResult_KazamResultArrow <- function(res, ...) {
  # TODO: Implement as needed, or remove (default DBI implementation exists)
  dbClearResult_KazamResult(res)
}
#' @rdname DBI
#' @export
setMethod("dbClearResult", "KazamResultArrow", dbClearResult_KazamResultArrow)
