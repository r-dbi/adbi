#' @rdname DBI
#' @inheritParams DBI::dbSendQuery
#' @usage NULL
dbSendQuery_KazamConnection_character <- function(conn, statement, ..., params = NULL) {
  if (!is.null(params)) {
    # TODO: Implement parameter binding
    testthat::skip("Not yet implemented: dbSendQuery(params = )")
  }

  # TODO: Implement, remove skip() call
  testthat::skip("Not yet implemented: dbSendQuery()")
  KazamResult(connection = conn, statement = statement)
}
#' @rdname DBI
#' @export
setMethod("dbSendQuery", c("KazamConnection", "character"), dbSendQuery_KazamConnection_character)
