#' Create result sets
#'
#' Creating result sets using [dbSendQuery()] (and by extension using
#' [dbGetQuery()]) mostly follows DBI specification. One way where adbi
#' deviates from DBI mechanisms is how the `bigint` setting is not only per
#' connection, but the per-connection setting can be overridden on a result
#' set basis. As default, the connection setting is applied, but passing one
#' of the accepted values as `bigint` when creating a result set will
#' subsequently use that setting for all fetches using this result set.
#'
#' @seealso adbi-driver
#' @rdname dbSendQuery
#' @param params Optional query parameters (forwarded to [dbBind()])
#' @param immediate Passing a value `TRUE` is intended for statements containing
#'   no placeholders and `FALSE` otherwise. The default value `NULL` will
#'   inspect the statement for presence of placeholders (will `PREPARE` the
#'   statement)
#' @param bigint The R type that 64-bit integer types should be mapped to,
#'   default is chosen according to the connection setting
#' @inheritParams DBI::dbSendQuery
#' @examples
#' if (requireNamespace("adbcsqlite")) {
#'   library(DBI)
#'   con <- dbConnect(adbi::adbi("adbcsqlite"), uri = ":memory:")
#'   dbWriteTable(con, "swiss", swiss)
#'   str(
#'     dbGetQuery(con, "SELECT Examination from swiss WHERE Agriculture < 30")
#'   )
#'   str(
#'     dbGetQuery(con, "SELECT Examination from swiss WHERE Agriculture < 30",
#'       bigint = "integer")
#'   )
#'   dbDisconnect(con)
#' }
#' @return An S4 class `AdbiResult` (inheriting from [DBIResult-class]).
#' @usage NULL
dbSendQuery_AdbiConnection_character <- function(conn, statement, ...,
    params = NULL, immediate = NULL, bigint = NULL) {

  if (!is.null(params)) {
    immediate <- FALSE
  }

  res <- AdbiResult(
    connection = conn,
    statement = statement,
    immediate = immediate,
    type = "query",
    bigint = bigint
  )

  if (!is.null(params)) {
    dbBind(res, params)
  }

  if (isTRUE(immediate)) {
    execute_statement(res)
  }

  res
}

#' @rdname dbSendQuery
#' @export
setMethod(
  "dbSendQuery",
  c("AdbiConnection", "character"),
  dbSendQuery_AdbiConnection_character
)
