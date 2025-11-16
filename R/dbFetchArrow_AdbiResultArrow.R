#' @rdname AdbiResultArrow-class
#' @inheritParams DBI::dbFetch
#' @usage NULL
dbFetchArrow_AdbiResultArrow <- function(res, ...) {
  check_statement_bound(res)

  if (identical(meta(res, "type"), "statement")) {
    warning("Statements are not expected to return results.", call. = FALSE)
    return(nanoarrow::basic_array_stream(list(data.frame())))
  }

  if (is.null(meta(res, "data")) && !isTRUE(meta(res, "has_completed"))) {
    execute_statement(res)
  }

  ret <- collect_array_stream(res)

  meta(res, "row_count") <- meta(res, "row_count") +
    sum(
      vapply(ret, `[[`, integer(1L), "length")
    )

  nanoarrow::basic_array_stream(ret, validate = FALSE)
}

#' @rdname AdbiResultArrow-class
#' @export
setMethod("dbFetchArrow", "AdbiResultArrow", dbFetchArrow_AdbiResultArrow)
