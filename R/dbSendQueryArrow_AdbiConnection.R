#' @rdname dbSendQuery
#' @inheritParams DBI::dbSendQueryArrow
#' @usage NULL
dbSendQueryArrow_AdbiConnection <- function(conn, statement, ...,
    params = NULL, immediate = is.null(params), bigint = NULL) {

  res <- AdbiResultArrow(
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
  "dbSendQueryArrow",
  "AdbiConnection",
  dbSendQueryArrow_AdbiConnection
)
