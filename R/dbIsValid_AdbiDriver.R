#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_AdbiDriver <- function(dbObj, ...) {
  inherits(dbObj@driver, "adbc_driver")
}

#' @rdname DBI
#' @export
setMethod("dbIsValid", "AdbiDriver", dbIsValid_AdbiDriver)
