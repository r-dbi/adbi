#' @rdname DBI
#' @inheritParams DBI::dbRollback
#' @usage NULL
dbRollback_AdbiConnection <- function(conn, ...) {

  if (...length()) {
    stop("Passing arguments as `...` is not supported", call. = FALSE)
  }

  state <- meta(conn, "transaction")

  if (is.null(state) || state == 0L) {
    stop("Cannot commit a transaction without transactional context.",
      call. = FALSE)
  }

  adbcdrivermanager::adbc_connection_rollback(conn@connection)

  adbcdrivermanager::adbc_connection_set_options(
    conn@connection,
    c(adbc.connection.autocommit = "true")
  )

  meta(conn, "transaction") <- state - 1L

  invisible(TRUE)
}

#' @rdname DBI
#' @export
setMethod("dbRollback", "AdbiConnection", dbRollback_AdbiConnection)
