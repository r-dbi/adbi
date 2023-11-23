#' @rdname DBI
#' @inheritParams DBI::dbGetInfo
#' @usage NULL
dbGetInfo_AdbiResult <- function(dbObj, ...) {
  # Optional
  getMethod("dbGetInfo", "DBIResult", asNamespace("DBI"))(dbObj, ...)
}
#' @rdname DBI
#' @export
setMethod("dbGetInfo", "AdbiResult", dbGetInfo_AdbiResult)
