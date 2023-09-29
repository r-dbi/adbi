#' @rdname DBI
#' @inheritParams DBI::dbClearResult
#' @usage NULL
dbClearResult_AdbiResult <- function(res, ...) {

  if (adbc_statement_is_valid(res@statement)) {

    release_statement(res)

  } else {

    warning("Statement already released.", call. = FALSE)
  }

  rm_result(res)

  invisible(TRUE)
}

#' @rdname DBI
#' @export
setMethod("dbClearResult", "AdbiResult", dbClearResult_AdbiResult)

release_statement <- function(x) {
  adbcdrivermanager::adbc_statement_release(x@statement)
  invisible(NULL)
}
