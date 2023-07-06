#' @rdname DBI
#' @inheritParams DBI::dbExistsTable
#' @usage NULL
dbExistsTable_KazamConnection_character <- function(conn, name, ...) {
  name <- dbQuoteIdentifier(conn, name)

  tryCatch(
    {
      dbGetQuery(conn, paste0("SELECT COUNT(*) FROM ", name, " WHERE 0 = 1"))
      TRUE
    },
    error = function(e) {
      FALSE
    }
  )
}
#' @rdname DBI
#' @export
setMethod("dbExistsTable", c("KazamConnection", "character"), dbExistsTable_KazamConnection_character)
