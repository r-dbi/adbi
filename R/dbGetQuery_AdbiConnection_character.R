#' @rdname AdbiConnection-class
#' @param n Number of rows to fetch, default -1
#' @usage NULL
dbGetQuery_AdbiConnection_character <- function(conn, statement, ..., n = -1L) {
  rs <- dbSendQuery(conn, statement, ...)
  on.exit(dbClearResult(rs))

  dbFetch(rs, n = n, ...)
}

#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbGetQuery",
  signature("AdbiConnection", "character"),
  dbGetQuery_AdbiConnection_character
)
