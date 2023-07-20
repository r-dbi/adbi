#' @rdname DBI
#' @inheritParams DBI::dbListTables
#' @usage NULL
dbListTables_AdbiConnection <- function(conn, ...) {
  testthat::skip("Not yet implemented: dbListTables(Connection)")
}
#' @rdname DBI
#' @export
setMethod("dbListTables", "AdbiConnection", dbListTables_AdbiConnection)
