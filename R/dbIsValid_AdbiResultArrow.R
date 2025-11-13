#' @rdname AdbiResultArrow-class
#' @param dbObj An object inheriting from [DBI::DBIObject-class],
#'  i.e. [DBI::DBIDriver-class], [DBI::DBIConnection-class],
#'  or a [DBI::DBIResult-class]
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_AdbiResultArrow <- function(dbObj, ...) {
  dbIsValid_AdbiResult(dbObj, ...)
}

#' @rdname AdbiResultArrow-class
#' @export
setMethod("dbIsValid", "AdbiResultArrow", dbIsValid_AdbiResultArrow)
