#' @rdname DBI
#' @inheritParams DBI::dbFetch
#' @usage NULL
dbFetchArrow_AdbiResultArrow <- function(res, n = NA, ...) {

  if (length(n) != 1L) {
    stop("Can only handle scalar values for `n`.", call. = FALSE)
  }

  if (!(is.na(n) || n == -1)) {
    stop("Allowed values for `n` are -1 and NA.", call. = FALSE)
  }

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
    return(nanoarrow::as_nanoarrow_array(data.frame()))
  }

  if (is.null(meta(res, "data")) && !isTRUE(meta(res, "has_completed"))) {
    execute_statement(res)
  }

  if (isTRUE(n == -1)) {

    testthat::skip("TODO: how do we get an array union from an array stream")

  } else if (isTRUE(is.na(n))) {

    ret <- get_next_batch(res)

  } else {

    stop("Unexpected branch.", call. = FALSE)
  }

  meta(res, "row_count") <- meta(res, "row_count") + ret$length

  ret
}

#' @rdname DBI
#' @export
setMethod("dbFetchArrow", "AdbiResultArrow", dbFetchArrow_AdbiResultArrow)
