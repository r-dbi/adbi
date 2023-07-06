#' @rdname DBI
#' @inheritParams DBI::dbSendQuery
#' @usage NULL
dbSendQueryArrow_KazamConnection <- function(conn, statement, ..., params = NULL) {
  # TODO: Implement as needed, or remove (default DBI implementation exists)

  if (!is.null(params)) {
    # TODO: Implement parameter binding
    testthat::skip("Not yet implemented: dbSendQueryArrow(params = )")
  }

  # TODO: Implement, remove skip() call
  testthat::skip("Not yet implemented: dbSendQueryArrow()")
  KazamResult(connection = conn, statement = statement)
}
#' @rdname DBI
#' @export
setMethod("dbSendQueryArrow", "KazamConnection", dbSendQueryArrow_KazamConnection)
