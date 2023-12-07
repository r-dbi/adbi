#' @rdname AdbiResult-class
#' @inheritParams DBI::dbClearResult
#' @usage NULL
dbClearResult_AdbiResult <- function(res, ...) {

  if (!is.null(meta(res, "data"))) {
    meta(res, "data")$release()
    meta(res, "data") <- NULL
  }

  if (adbc_statement_is_valid(res@statement)) {

    adbcdrivermanager::adbc_statement_release(res@statement)

  } else {

    warning("Statement already released.", call. = FALSE)
  }

  rm_result(res)

  invisible(TRUE)
}

#' @rdname AdbiResult-class
#' @export
setMethod("dbClearResult", "AdbiResult", dbClearResult_AdbiResult)
