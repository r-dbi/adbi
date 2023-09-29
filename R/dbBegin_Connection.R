#' @rdname DBI
#' @inheritParams DBI::dbBegin
#' @usage NULL
dbBegin_AdbiConnection <- function(conn, ...) {
  adbcdrivermanager::adbc_connection_set_options(
    conn@connection,
    c(adbc.connection.autocommit = "false")
  )
}
#' @rdname DBI
#' @export
setMethod("dbBegin", "AdbiConnection", dbBegin_AdbiConnection)
