#' Create result sets
#'
#' Creating result sets using [DBI::dbSendQuery()] (and by extension using
#' [DBI::dbGetQuery()]) mostly follows DBI specification.
#' One way where adbi deviates from DBI mechanisms is how the `bigint` setting
#' is not only per connection, but the per-connection setting can be overridden
#' on a result set basis.
#' As default, the connection setting is applied, but passing one of the
#' accepted values as `bigint` when creating a result set will subsequently use
#' that setting for all fetches using this result set.
#'
#' Multiple open result sets per connection are supported and support can be
#' disabled by setting `options(adbi.allow_multiple_results = FALSE)`.
#' If not enabled, creating a new result will finalize potential other results
#' and throw a warning.
#'
#' If parameter metadata is unavailable, bind before fetching when parameters
#' are needed.
#' Without metadata, adbi does not check the number or names of the
#' parameters, so a mismatch is reported only if the driver checks for it,
#' possibly not until the statement is executed.
#'
#' Without metadata, adbi cannot tell whether a statement sent with
#' `immediate = NULL` has placeholders, so such a statement runs only once it
#' is bound or [DBI::dbGetRowsAffected()] is called, as [DBI::dbExecute()]
#' does.
#' Pass `immediate = TRUE` for a statement without placeholders to run when it
#' is sent.
#' For an unbound statement sent with `immediate = FALSE`,
#' [DBI::dbGetRowsAffected()] returns `NA`.
#'
#' @seealso adbi-driver
#' @rdname dbSendQuery
#' @param conn A [DBI::DBIConnection][DBI::DBIConnection-class] object,
#'   as returned by [DBI::dbConnect()].
#' @param statement a character string containing SQL.
#' @param params Optional query parameters (forwarded to [DBI::dbBind()])
#' @param immediate Use `TRUE` for direct execution, `FALSE` to bind parameters,
#'   or `NULL` to inspect placeholders when the driver supports it.
#' @param bigint The R type that 64-bit integer types should be mapped to,
#'   default is chosen according to the connection setting
#' @inheritParams DBI::dbSendQuery
#' @examples
#' if (requireNamespace("adbcsqlite")) {
#'   library(DBI)
#'   con <- dbConnect(adbi::adbi(pkg = "adbcsqlite"), uri = ":memory:")
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
#' @return An S4 class `AdbiResult` (inheriting from [DBI::DBIResult-class]).
#' @usage NULL
dbSendQuery_AdbiConnection_character <- function(
  conn,
  statement,
  ...,
  params = NULL,
  immediate = NULL,
  bigint = NULL
) {
  if (!is.null(params)) {
    immediate <- FALSE
  }

  res <- AdbiResult(
    connection = conn,
    statement = statement,
    immediate = immediate,
    type = "query",
    bigint = bigint,
    rows_affected_callback = conn@rows_affected_callback
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
