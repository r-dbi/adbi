#' @rdname AdbiDriver-class
#' @inheritParams DBI::dbConnect
#' @usage NULL
dbConnect_AdbiDriver <- function(drv, ...) {
  AdbiConnection(drv, ...)
}

#' @rdname AdbiDriver-class
#' @export
setMethod("dbConnect", "AdbiDriver", dbConnect_AdbiDriver)
