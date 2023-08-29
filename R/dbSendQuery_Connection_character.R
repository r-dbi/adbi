#' @rdname DBI
#' @inheritParams DBI::dbSendQuery
#' @usage NULL
dbSendQuery_AdbiConnection_character <- function(conn, statement, ...,
  params = NULL) {

  if (!is.null(params)) {
    # TODO: Implement parameter binding
    testthat::skip("Not yet implemented: dbSendQuery(params = )")
  }

  AdbiResult(connection = conn, statement = statement)
}

#' @rdname DBI
#' @export
setMethod(
  "dbSendQuery",
  c("AdbiConnection", "character"),
  dbSendQuery_AdbiConnection_character
)
