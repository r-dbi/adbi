#' @rdname DBI
#' @inheritParams DBI::dbSendStatement
#' @usage NULL
dbSendStatement_AdbiConnection_character <- function(conn, statement, ...,
  params = NULL) {

  if (!is.null(params)) {
    testthat::skip("Not yet implemented: dbSendStatement(params = )")
  }

  AdbiResult(connection = conn, statement = statement)
}
#' @rdname DBI
#' @export
setMethod(
  "dbSendStatement",
  c("AdbiConnection", "character"),
  dbSendStatement_AdbiConnection_character
)
