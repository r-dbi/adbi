#' @rdname DBI
#' @inheritParams DBI::dbBind
#' @usage NULL
dbBind_KazamResult <- function(res, params, ...) {
  testthat::skip("Not yet implemented: dbBind(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbBind", "KazamResult", dbBind_KazamResult)
