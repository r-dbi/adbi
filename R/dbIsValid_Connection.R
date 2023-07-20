#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_AdbiConnection <- function(dbObj, ...) {
  isTRUE(attr(dbObj@connection, "is_open"))
}

#' @rdname DBI
#' @export
setMethod("dbIsValid", "AdbiConnection", dbIsValid_AdbiConnection)
