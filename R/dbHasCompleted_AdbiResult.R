#' @rdname AdbiResult-class
#' @inheritParams DBI::dbHasCompleted
#' @usage NULL
dbHasCompleted_AdbiResult <- function(res, ...) {

  if (!dbIsValid(res)) {
    stop("Cannot return statement of invalid result.", call. = FALSE)
  }

  meta(res, "has_completed") && is_statement_bound(res)
}

#' @rdname AdbiResult-class
#' @export
setMethod("dbHasCompleted", "AdbiResult", dbHasCompleted_AdbiResult)
