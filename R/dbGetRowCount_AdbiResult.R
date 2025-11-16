#' @rdname AdbiResult-class
#' @inheritParams DBI::dbGetRowCount
#' @usage NULL
dbGetRowCount_AdbiResult <- function(res, ...) {
  if (!dbIsValid(res)) {
    stop("Cannot return row count for invalid results.", call. = FALSE)
  }

  res <- meta(res, "row_count")

  if (is.null(res)) {
    return(0L)
  }

  res
}

#' @rdname AdbiResult-class
#' @export
setMethod("dbGetRowCount", "AdbiResult", dbGetRowCount_AdbiResult)
