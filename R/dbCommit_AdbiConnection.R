#' @rdname AdbiConnection-class
#' @inheritParams DBI::dbCommit
#' @usage NULL
dbCommit_AdbiConnection <- function(conn, ...) {
  if (...length()) {
    stop("Passing arguments as `...` is not supported", call. = FALSE)
  }

  state <- meta(conn, "transaction")

  if (is.null(state) || state == 0L) {
    stop(
      "Cannot commit a transaction without transactional context.",
      call. = FALSE
    )
  }

  adbcdrivermanager::adbc_connection_commit(conn@connection)

  adbcdrivermanager::adbc_connection_set_options(
    conn@connection,
    c(adbc.connection.autocommit = "true")
  )

  meta(conn, "transaction") <- state - 1L

  invisible(TRUE)
}

#' @rdname AdbiConnection-class
#' @export
setMethod("dbCommit", "AdbiConnection", dbCommit_AdbiConnection)
