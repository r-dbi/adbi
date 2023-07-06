#' @rdname DBI
#' @inheritParams DBI::dbDataType
#' @usage NULL
dbDataType_KazamDriver <- function(dbObj, obj, ...) {
  # Optional: Can remove this if all data types conform to SQL-92
  tryCatch(
    callNextMethod(...),
    error = function(e) testthat::skip("Not yet implemented: dbDataType(Driver)")
  )
}
#' @rdname DBI
#' @export
setMethod("dbDataType", "KazamDriver", dbDataType_KazamDriver)
