#' @rdname DBI
#' @inheritParams DBI::dbBind
#' @usage NULL
dbBind_AdbiResult <- function(res, params, ...) {
  testthat::skip("Not yet implemented: dbBind(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbBind", "AdbiResult", dbBind_AdbiResult)
