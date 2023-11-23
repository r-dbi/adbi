#' @rdname DBI
#' @inheritParams DBI::dbConnect
#' @usage NULL
dbConnect_AdbiDriver <- function(drv, ...) {
  AdbiConnection(drv, ...)
}
#' @rdname DBI
#' @export
setMethod("dbConnect", "AdbiDriver", dbConnect_AdbiDriver)
