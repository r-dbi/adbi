#' @rdname AdbiResultArrow-class
#' @inheritParams DBI::dbHasCompleted
#' @usage NULL
dbHasCompleted_AdbiResultArrow <- function(res, ...) {
  dbHasCompleted_AdbiResult(res, ...)
}

#' @rdname AdbiResultArrow-class
#' @export
setMethod("dbHasCompleted", "AdbiResultArrow", dbHasCompleted_AdbiResultArrow)
