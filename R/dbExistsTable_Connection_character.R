#' @rdname DBI
#' @inheritParams DBI::dbExistsTable
#' @usage NULL
dbExistsTable_AdbiConnection_character <- function(conn, name, ...) {
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
setMethod("dbExistsTable", c("AdbiConnection", "character"), dbExistsTable_AdbiConnection_character)
