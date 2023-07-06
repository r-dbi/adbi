#' @rdname DBI
#' @inheritParams DBI::dbListFields
#' @usage NULL
dbListFields_KazamConnection_character <- function(conn, name, ...) {
  testthat::skip("Not yet implemented: dbListFields(Connection, character)")
}
#' @rdname DBI
#' @export
setMethod("dbListFields", c("KazamConnection", "character"), dbListFields_KazamConnection_character)
