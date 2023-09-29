#' @rdname DBI
#' @inheritParams DBI::dbCommit
#' @usage NULL
dbCommit_AdbiConnection <- function(conn, ...) {
  adbcdrivermanager::adbc_connection_set_options(
    conn@connection,
    c(adbc.connection.autocommit = "true")
  )
}

#' @rdname DBI
#' @export
setMethod("dbCommit", "AdbiConnection", dbCommit_AdbiConnection)
