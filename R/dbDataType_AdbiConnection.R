#' @rdname AdbiConnection-class
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

#' @rdname AdbiConnection-class
#' @export
setMethod("dbDataType", "AdbiConnection", dbDataType_AdbiConnection)
