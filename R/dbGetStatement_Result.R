#' @rdname DBI
#' @inheritParams DBI::dbGetStatement
#' @usage NULL
dbGetStatement_KazamResult <- function(res, ...) {
  testthat::skip("Not yet implemented: dbGetStatement(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbGetStatement", "KazamResult", dbGetStatement_KazamResult)
