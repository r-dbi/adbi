#' @rdname AdbiDriver-class
#' @inheritParams DBI::dbDataType
#' @usage NULL
dbDataType_AdbiDriver <- function(dbObj, obj, ...) {
  db_data_type(obj, dbObj@driver)
}

#' @rdname AdbiDriver-class
#' @export
setMethod("dbDataType", "AdbiDriver", dbDataType_AdbiDriver)
