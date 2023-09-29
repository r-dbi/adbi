#' @rdname DBI
#' @inheritParams DBI::dbDisconnect
#' @usage NULL
dbDisconnect_AdbiConnection <- function(conn, ...) {

  n_res <- length(meta(conn, "results"))

  if (n_res > 0L) {

    message("There are ", n_res, " result(s) in use. The connection will be ",
      "released when they are closed")

    meta(conn, "disconnect") <- TRUE

    return(invisible(FALSE))
  }

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
