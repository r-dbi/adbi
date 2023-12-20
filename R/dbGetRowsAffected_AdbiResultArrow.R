#' @rdname AdbiResultArrow-class
#' @inheritParams DBI::dbGetRowsAffected
#' @usage NULL
dbGetRowsAffected_AdbiResultArrow <- function(res, ...) {
  dbGetRowsAffected_AdbiResult(res, ...)
}

#' @rdname AdbiResultArrow-class
#' @export
setMethod(
  "dbGetRowsAffected",
  "AdbiResultArrow",
  dbGetRowsAffected_AdbiResultArrow
)
