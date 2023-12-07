#' @rdname AdbiResult-class
#' @inheritParams DBI::dbGetStatement
#' @usage NULL
dbGetStatement_AdbiResult <- function(res, ...) {

  if (!dbIsValid(res)) {
    stop("Cannot return statement of invalid result.", call. = FALSE)
  }

  meta(res, "sql")
}

#' @rdname AdbiResult-class
#' @export
setMethod("dbGetStatement", "AdbiResult", dbGetStatement_AdbiResult)
