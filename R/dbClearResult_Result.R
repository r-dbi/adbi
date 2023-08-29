#' @rdname DBI
#' @inheritParams DBI::dbClearResult
#' @usage NULL
dbClearResult_AdbiResult <- function(res, ...) {

  if (adbc_statement_is_valid(res@statement)) {

    adbcdrivermanager::adbc_statement_release(res@statement)

  } else {

    warning("Statement already released.", call. = FALSE)
  }

  invisible(TRUE)
}

#' @rdname DBI
#' @export
setMethod("dbClearResult", "AdbiResult", dbClearResult_AdbiResult)
