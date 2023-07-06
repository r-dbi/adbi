#' @rdname DBI
#' @inheritParams DBI::dbGetInfo
#' @usage NULL
dbGetInfo_KazamResult <- function(dbObj, ...) {
  # Optional
  getMethod("dbGetInfo", "DBIResult", asNamespace("DBI"))(dbObj, ...)
}
#' @rdname DBI
#' @export
setMethod("dbGetInfo", "KazamResult", dbGetInfo_KazamResult)
