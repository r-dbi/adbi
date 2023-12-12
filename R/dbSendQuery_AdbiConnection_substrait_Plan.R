#' @rdname dbSendQuery
#' @export
setMethod(
  "dbSendQuery",
  c("AdbiConnection", "substrait_Plan"),
  dbSendQuery_AdbiConnection_character
)
