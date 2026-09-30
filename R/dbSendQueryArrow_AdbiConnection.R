#' @rdname dbSendQuery
#' @inheritParams DBI::dbSendQueryArrow
#' @usage NULL
dbSendQueryArrow_AdbiConnection <- function(
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

  res <- AdbiResultArrow(
    connection = conn,
    statement = statement,
    immediate = immediate,
    type = "query",
    bigint = bigint,
    rows_affected_callback = conn@rows_affected_callback
  )

  on.exit(dbClearResult(res))

  if (!is.null(params)) {
    dbBind(res, params)
  }

  if (isTRUE(immediate)) {
    execute_statement(res)
  }

  on.exit()
  res
}

#' @rdname dbSendQuery
#' @export
setMethod(
  "dbSendQueryArrow",
  "AdbiConnection",
  dbSendQueryArrow_AdbiConnection
)
