#' @rdname AdbiResultArrow-class
#' @inheritParams DBI::dbGetStatement
#' @usage NULL
dbGetStatement_AdbiResultArrow <- function(res, ...) {
  dbGetStatement_AdbiResult(res, ...)
}

#' @rdname AdbiResultArrow-class
#' @export
setMethod("dbGetStatement", "AdbiResultArrow", dbGetStatement_AdbiResultArrow)
