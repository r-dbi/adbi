#' @rdname AdbiResultArrow-class
#' @inheritParams DBI::dbFetch
#' @usage NULL
dbFetchArrow_AdbiResultArrow <- function(res, ...) {

  if (isFALSE(meta(res, "immediate"))) {

    n_bound <- meta(res, "bound")

    if (is.null(n_bound) || n_bound < 1L) {

      stop(
        "A statement created with `immediate = FALSE` should be prepared ",
        "before being executed, typically by a call to `dbBind()`.",
        call. = FALSE
      )
    }
  }

  if (identical(meta(res, "type"), "statement")) {
    warning("Statements are not expected to return results.", call. = FALSE)
    return(nanoarrow::basic_array_stream(list(data.frame())))
  }

  if (is.null(meta(res, "data")) && !isTRUE(meta(res, "has_completed"))) {
    execute_statement(res)
  }

  ret <- collect_array_stream(res)

  meta(res, "row_count") <- meta(res, "row_count") + sum(
    vapply(ret, `[[`, integer(1L), "length")
  )

  nanoarrow::basic_array_stream(ret, validate = FALSE)
}

#' @rdname AdbiResultArrow-class
#' @export
setMethod("dbFetchArrow", "AdbiResultArrow", dbFetchArrow_AdbiResultArrow)
