#' @rdname DBI
#' @inheritParams DBI::dbIsValid
#' @usage NULL
dbIsValid_AdbiConnection <- function(dbObj, ...) {
  adbc_connection_is_valid(dbObj@connection) &&
    adbc_database_is_valid(dbObj@database)
}

#' @rdname DBI
#' @export
setMethod("dbIsValid", "AdbiConnection", dbIsValid_AdbiConnection)

adbc_connection_is_valid <- function(x) {
  adbc_is_valid(x, "adbc_connection")
}

adbc_database_is_valid <- function(x) {
  adbc_is_valid(x, "adbc_database")
}
