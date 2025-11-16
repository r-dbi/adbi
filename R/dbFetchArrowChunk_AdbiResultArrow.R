#' @rdname AdbiResultArrow-class
#' @inheritParams DBI::dbFetch
#' @usage NULL
dbFetchArrowChunk_AdbiResultArrow <- function(res, ...) {

  check_statement_bound(res)

  if (identical(meta(res, "type"), "statement")) {
    warning("Statements are not expected to return results.", call. = FALSE)
    return(nanoarrow::as_nanoarrow_array(data.frame()))
  }

  if (is.null(meta(res, "data")) && !isTRUE(meta(res, "has_completed"))) {
    execute_statement(res)
  }

  ret <- get_next_batch(res)

  meta(res, "row_count") <- meta(res, "row_count") + ret$length

  ret
}

#' @rdname AdbiResultArrow-class
#' @export
setMethod(
  "dbFetchArrowChunk",
  "AdbiResultArrow",
  dbFetchArrowChunk_AdbiResultArrow
)
