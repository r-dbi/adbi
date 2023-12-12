#' @rdname dbSendQuery
#' @export
setMethod(
  "dbSendStatement",
  c("AdbiConnection", "substrait_Plan"),
  dbSendStatement_AdbiConnection_character
)
