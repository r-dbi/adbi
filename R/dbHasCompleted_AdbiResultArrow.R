#' @rdname DBI
#' @inheritParams DBI::dbHasCompleted
#' @usage NULL
dbHasCompleted_AdbiResultArrow <- function(res, ...) {
  dbHasCompleted_AdbiResult(res, ...)
}

#' @rdname DBI
#' @export
setMethod("dbHasCompleted", "AdbiResultArrow", dbHasCompleted_AdbiResultArrow)
