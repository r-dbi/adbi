#' @rdname DBI
#' @inheritParams DBI::dbListTables
#' @usage NULL
dbListTables_KazamConnection <- function(conn, ...) {
  testthat::skip("Not yet implemented: dbListTables(Connection)")
}
#' @rdname DBI
#' @export
setMethod("dbListTables", "KazamConnection", dbListTables_KazamConnection)
