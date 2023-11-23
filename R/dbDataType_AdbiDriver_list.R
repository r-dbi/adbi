#' @rdname DBI
#' @inheritParams DBI::dbDataType
#' @usage NULL
dbDataType_AdbiDriver_list <- function(dbObj, obj, ...) {
  # https://github.com/r-dbi/DBI/issues/70
  callNextMethod(...)
}
#' @rdname DBI
#' @export
setMethod("dbDataType", c("AdbiDriver", "list"), dbDataType_AdbiDriver_list)
