#' @rdname AdbiDriver-class
#' @inheritParams DBI::dbDataType
#' @usage NULL
dbDataType_AdbiDriver <- function(dbObj, obj, ...) {
  if (
    inherits(obj, "blob") &&
      (is.null(dbObj@driver) || is.character(dbObj@driver))
  ) {
    stop(
      "`dbDataType()` for blob objects requires a connection or a concrete `adbc_driver`.",
      call. = FALSE
    )
  }

  db_data_type(obj, dbObj@driver)
}

#' @rdname AdbiDriver-class
#' @export
setMethod("dbDataType", "AdbiDriver", dbDataType_AdbiDriver)
