#' @rdname DBI
#' @inheritParams DBI::dbDisconnect
#' @usage NULL
dbDisconnect_AdbiConnection <- function(conn, ...) {

  if (isTRUE(attr(conn@connection, "is_open"))) {

    adbcdrivermanager::adbc_connection_release(conn@connection)
    attr(conn@connection, "is_open") <- FALSE

  } else {

    warning("Connection already closed.", call. = FALSE)
  }

  if (isTRUE(attr(conn@database, "is_open"))) {

    adbcdrivermanager::adbc_database_release(conn@database)
    attr(conn@database, "is_open") <- FALSE

  } else {

    warning("Database already released.", call. = FALSE)
  }

  invisible(TRUE)
}

#' @rdname DBI
#' @export
setMethod("dbDisconnect", "AdbiConnection", dbDisconnect_AdbiConnection)
