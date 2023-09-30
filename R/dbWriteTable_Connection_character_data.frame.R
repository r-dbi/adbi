#' @rdname DBI
#' @inheritParams DBI::dbWriteTable
#' @usage NULL
dbWriteTable_AdbiConnection_character_data.frame <- function(conn, name, value, ...) {
  dbWriteTable(conn, Id(table = name), value, ...)
}

#' @rdname DBI
#' @export
setMethod(
  "dbWriteTable",
  c("AdbiConnection", "character", "data.frame"),
  dbWriteTable_AdbiConnection_character_data.frame
)
