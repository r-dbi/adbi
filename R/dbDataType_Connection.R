#' @rdname DBI
#' @inheritParams DBI::dbDataType
#' @usage NULL
dbDataType_KazamConnection <- function(dbObj, obj, ...) {
  tryCatch(
    callNextMethod(...),
    error = function(e) testthat::skip("Not yet implemented: dbDataType(Connection)")
  )
}
#' @rdname DBI
#' @export
setMethod("dbDataType", "KazamConnection", dbDataType_KazamConnection)
