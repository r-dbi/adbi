#' @rdname AdbiDriver-class
#' @inheritParams DBI::dbDataType
#' @usage NULL
dbDataType_AdbiDriver_list <- function(dbObj, obj, ...) {
  # https://github.com/r-dbi/DBI/issues/70
  callNextMethod(...)
}

#' @rdname AdbiDriver-class
#' @export
setMethod("dbDataType", c("AdbiDriver", "list"), dbDataType_AdbiDriver_list)
