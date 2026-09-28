#' @rdname AdbiConnection-class
#' @inheritParams DBI::dbDataType
#' @usage NULL
dbDataType_AdbiConnection <- function(dbObj, obj, ...) {
  db_data_type(obj, dbObj@connection$database$driver, dbObj@connection)
}

#' @rdname AdbiConnection-class
#' @export
setMethod("dbDataType", "AdbiConnection", dbDataType_AdbiConnection)

db_data_type <- function(x, drv, con = NULL) {
  if (inherits(x, "blob")) {
    db_data_type_blob(drv, con)
  } else {
    dbDataType(ANSI(), x)
  }
}
