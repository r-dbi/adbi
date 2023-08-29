#' @rdname DBI
#' @inheritParams DBI::dbGetStatement
#' @usage NULL
dbGetStatement_AdbiResult <- function(res, ...) {
  testthat::skip("Not yet implemented: dbGetStatement(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbGetStatement", "AdbiResult", dbGetStatement_AdbiResult)
