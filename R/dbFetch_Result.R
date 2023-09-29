#' @rdname DBI
#' @inheritParams DBI::dbFetch
#' @usage NULL
dbFetch_AdbiResult <- function(res, n = -1, ...) {

  if (!n == -1) {
    testthat::skip("not implmented")
  }

  if (isFALSE(meta(res, "immediate"))) {

    n_bound <- meta(res, "bound")

    if (is.null(n_bound) || n_bound < 1L) {

      stop("A statement created with `immediate = FALSE` should be prepared ",
        "before being executed, typically by a call to `dbBind()`.",
        call. = FALSE)
    }
  }

  if (is.null(meta(res, "data"))) {
    ret <- execute_statement(res)
  } else {
    ret <- meta(res, "data")
    meta(res, "data") <- NULL
  }

  as.data.frame(ret)
}

#' @rdname DBI
#' @export
setMethod("dbFetch", "AdbiResult", dbFetch_AdbiResult)

execute_statement <- function(res) {
  strm <- nanoarrow::nanoarrow_allocate_array_stream()
  adbcdrivermanager::adbc_statement_execute_query(res@statement, stream = strm)
  strm
}
