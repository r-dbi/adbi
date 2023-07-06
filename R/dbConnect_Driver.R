#' @rdname DBI
#' @inheritParams DBI::dbConnect
#' @usage NULL
dbConnect_KazamDriver <- function(drv, ...) {
  # TODO: Implement
  KazamConnection()
}
#' @rdname DBI
#' @export
setMethod("dbConnect", "KazamDriver", dbConnect_KazamDriver)
