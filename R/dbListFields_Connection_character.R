#' @rdname DBI
#' @inheritParams DBI::dbListFields
#' @usage NULL
dbListFields_AdbiConnection_character <- function(conn, name, ...) {
  dbListFields(conn, Id(table = name), ...)
}

#' @rdname DBI
#' @export
setMethod(
  "dbListFields",
  c("AdbiConnection", "character"),
  dbListFields_AdbiConnection_character
)
