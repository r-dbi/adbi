#' @rdname AdbiResult-class
#' @param dbObj An object inheriting from [DBI::DBIObject-class],
#'  i.e. [DBI::DBIDriver-class], [DBI::DBIConnection-class],
#'  or a [DBI::DBIResult-class]
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_AdbiResult <- function(dbObj, ...) {
  adbc_statement_is_valid(dbObj@statement)
}

#' @rdname AdbiResult-class
#' @export
setMethod("dbIsValid", "AdbiResult", dbIsValid_AdbiResult)

adbc_statement_is_valid <- function(x) {
  adbc_is_valid(x, "adbc_statement")
}
