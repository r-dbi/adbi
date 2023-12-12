#' @rdname dbSendQuery
#' @inheritParams DBI::dbSendQueryArrow
#' @usage NULL
dbSendQueryArrow_AdbiConnection <- function(conn, statement, ...,
    params = NULL, immediate = NULL) {

  if (!is.null(params)) {
    immediate <- FALSE
  }

  res <- AdbiResultArrow(
    connection = conn,
    statement = statement,
    immediate = immediate,
    type = "query"
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
