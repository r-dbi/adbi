#' @rdname DBI
#' @inheritParams DBI::dbFetch
#' @usage NULL
dbFetch_AdbiResult <- function(res, n = -1, ...) {

  if (!n == -1) {
    testthat::skip("not implmented")
  }

  strm <- nanoarrow::nanoarrow_allocate_array_stream()

  adbcdrivermanager::adbc_statement_execute_query(res@statement, stream = strm)

  as.data.frame(strm)
}

#' @rdname DBI
#' @export
setMethod("dbFetch", "AdbiResult", dbFetch_AdbiResult)
