#' @rdname DBI
#' @inheritParams DBI::dbDisconnect
#' @usage NULL
dbDisconnect_KazamConnection <- function(conn, ...) {
  if (!dbIsValid(conn)) {
    warning("Connection already closed.", call. = FALSE)
  }

  # TODO: Free resources
  invisible(TRUE)
}
#' @rdname DBI
#' @export
setMethod("dbDisconnect", "KazamConnection", dbDisconnect_KazamConnection)
