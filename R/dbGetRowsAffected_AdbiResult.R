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

  if (!is_statement_bound(res)) {
    return(NA_integer_)
  }

  if (is.null(meta(res, "rows_affected"))) {
    execute_statement(res)
  }

  res@rows_affected_callback(
    meta(res, "rows_affected")
  )
}

#' @rdname AdbiResult-class
#' @export
setMethod("dbGetRowsAffected", "AdbiResult", dbGetRowsAffected_AdbiResult)
