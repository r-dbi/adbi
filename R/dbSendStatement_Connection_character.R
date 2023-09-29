#' @rdname DBI
#' @param immediate Passing a value `TRUE` is intended for statements containing
#'   no placeholders and `FALSE` otherwise. The default value `NULL` will
#'   inspect the statement for presence of placeholders (will `PREPARE` the
#'   statement)
#' @inheritParams DBI::dbSendStatement
#' @usage NULL
dbSendStatement_AdbiConnection_character <- function(conn, statement, ...,
    params = NULL, immediate = NULL) {

  if (!is.null(params)) {
    testthat::skip("Not yet implemented: dbSendStatement(params = )")
  }

  AdbiResult(
    connection = conn,
    statement = statement,
    immediate = immediate
  )
}
#' @rdname DBI
#' @export
setMethod(
  "dbSendStatement",
  c("AdbiConnection", "character"),
  dbSendStatement_AdbiConnection_character
)
