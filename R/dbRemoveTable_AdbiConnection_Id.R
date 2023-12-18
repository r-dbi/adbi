#' @include dbRemoveTable_AdbiConnection_character.R
NULL

#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbRemoveTable",
  c("AdbiConnection", "Id"),
  dbRemoveTable_AdbiConnection
)
