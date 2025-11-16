#' @rdname AdbiDriver-class
#' @param dbObj A object inheriting from [DBI::DBIDriver][DBI::DBIDriver-class]
#'   or [DBI::DBIConnection][DBI::DBIConnection-class]
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_AdbiDriver <- function(dbObj, ...) {
  inherits(dbObj@driver, "adbc_driver")
}

#' @rdname AdbiDriver-class
#' @export
setMethod("dbIsValid", "AdbiDriver", dbIsValid_AdbiDriver)
