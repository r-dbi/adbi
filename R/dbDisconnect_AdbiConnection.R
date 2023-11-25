#' @rdname DBI
#' @inheritParams DBI::dbDisconnect
#' @param force Close open results when disconnecting
#' @usage NULL
dbDisconnect_AdbiConnection <- function(conn,
  force = getOption("adbi.force_close_results", FALSE), ...) {

  n_res <- length(meta(conn, "results"))

  if (n_res && isTRUE(force)) {

    warning("There are ", n_res, " open result(s) in use. Force closing ",
      "can be disabled by setting `options(adbi.force_close_results = FALSE)`.")

    for (res in meta(conn, "results")) {
      dbClearResult(res)
    }

    meta(conn, "results") <- list()

  } else if (n_res) {

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
