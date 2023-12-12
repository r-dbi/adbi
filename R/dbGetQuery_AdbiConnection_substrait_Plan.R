#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbGetQuery",
  signature("AdbiConnection", "substrait_Plan"),
  dbGetQuery_AdbiConnection_character
)
