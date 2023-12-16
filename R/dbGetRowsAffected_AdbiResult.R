#' @rdname AdbiResult-class
#' @inheritParams DBI::dbGetRowsAffected
#' @usage NULL
dbGetRowsAffected_AdbiResult <- function(res, ...) {

  if (!dbIsValid(res)) {
    stop("Cannot return row count for invalid results.", call. = FALSE)
  }

  if (identical(meta(res, "type"), "query")) {
    return(0L)
  }

  if (is.null(meta(res, "rows_affected"))) {
    execute_statement(res)
  }

  out <- meta(res, "rows_affected")
  if (out < 0) {
    out <- NA_integer_
  }
  out
}

#' @rdname AdbiResult-class
#' @export
setMethod("dbGetRowsAffected", "AdbiResult", dbGetRowsAffected_AdbiResult)
