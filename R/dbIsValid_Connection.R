#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_KazamConnection <- function(dbObj, ...) {
  # TODO: Implement
  TRUE
}
#' @rdname DBI
#' @export
setMethod("dbIsValid", "KazamConnection", dbIsValid_KazamConnection)
