#' @rdname DBI
#' @inheritParams DBI::dbDataType
#' @usage NULL
dbDataType_AdbiConnection <- function(dbObj, obj, ...) {
  tryCatch(
    callNextMethod(...),
    error = function(e) {
      testthat::skip("Not yet implemented: dbDataType(Connection)")
    }
  )
}
#' @rdname DBI
#' @export
setMethod("dbDataType", "AdbiConnection", dbDataType_AdbiConnection)
