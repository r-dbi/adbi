#' @rdname AdbiConnection-class
#' @inheritParams DBI::dbBegin
#' @usage NULL
dbBegin_AdbiConnection <- function(conn, ...) {

  if (...length()) {
    stop("Passing arguments as `...` is not supported", call. = FALSE)
  }

  state <- meta(conn, "transaction")

  if (!is.null(state) && state != 0L) {
    stop("Nested transactions are not supported.", call. = FALSE)
  }

  adbcdrivermanager::adbc_connection_set_options(
    conn@connection,
    c(adbc.connection.autocommit = "false")
  )

  if (is.null(state)) {
    meta(conn, "transaction") <- 1L
  } else {
    meta(conn, "transaction") <- state + 1L
  }

  invisible(TRUE)
}

#' @rdname AdbiConnection-class
#' @export
setMethod("dbBegin", "AdbiConnection", dbBegin_AdbiConnection)
