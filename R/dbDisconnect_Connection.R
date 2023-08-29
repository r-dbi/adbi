#' @rdname DBI
#' @inheritParams DBI::dbDisconnect
#' @usage NULL
dbDisconnect_AdbiConnection <- function(conn, ...) {

  if (adbc_connection_is_valid(conn@connection)) {

    adbcdrivermanager::adbc_connection_release(conn@connection)

  } else {

    warning("Connection already closed.", call. = FALSE)
  }

  if (adbc_database_is_valid(conn@database)) {

    adbcdrivermanager::adbc_database_release(conn@database)

  } else {

    warning("Database already released.", call. = FALSE)
  }

  invisible(TRUE)
}

#' @rdname DBI
#' @export
setMethod("dbDisconnect", "AdbiConnection", dbDisconnect_AdbiConnection)
