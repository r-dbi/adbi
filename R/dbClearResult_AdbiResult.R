#' @rdname AdbiResult-class
#' @param res An object inheriting from [DBI::DBIResult][DBI::DBIResult-class].
#' @inheritParams DBI::dbClearResult
#' @usage NULL
dbClearResult_AdbiResult <- function(res, ...) {
  if (!is.null(meta(res, "data"))) {
    meta(res, "data")$release()
    meta(res, "data") <- NULL
  }

  if (adbc_statement_is_valid(res@statement)) {
    adbc_release(res@statement)
  } else {
    warning("Statement already released.", call. = FALSE)
  }

  rm_result(res)

  invisible(TRUE)
}

#' @rdname AdbiResult-class
#' @export
setMethod("dbClearResult", "AdbiResult", dbClearResult_AdbiResult)
