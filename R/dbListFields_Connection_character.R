#' @rdname DBI
#' @inheritParams DBI::dbListFields
#' @usage NULL
dbListFields_AdbiConnection_character <- function(conn, name, ...) {
  testthat::skip("Not yet implemented: dbListFields(Connection, character)")
}
#' @rdname DBI
#' @export
setMethod("dbListFields", c("AdbiConnection", "character"), dbListFields_AdbiConnection_character)
