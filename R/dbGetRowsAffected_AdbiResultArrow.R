#' @rdname DBI
#' @inheritParams DBI::dbGetRowsAffected
#' @usage NULL
dbGetRowsAffected_AdbiResultArrow <- function(res, ...) {
  dbGetRowsAffected_AdbiResult(res, ...)
}

#' @rdname DBI
#' @export
setMethod(
  "dbGetRowsAffected",
  "AdbiResultArrow",
  dbGetRowsAffected_AdbiResultArrow
)
