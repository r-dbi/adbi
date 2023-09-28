#' @rdname DBI
#' @inheritParams DBI::dbBind
#' @usage NULL
dbBind_AdbiResult <- function(res, params, ...) {

  # can we call this only once? if not, can we query the "prep" status?
  adbcdrivermanager::adbc_statement_prepare(res@statement)
  # any advantage of bind_stream over bind?
  adbcdrivermanager::adbc_statement_bind(res@statement, params)

  invisible(res)
}
#' @rdname DBI
#' @export
setMethod("dbBind", "AdbiResult", dbBind_AdbiResult)
