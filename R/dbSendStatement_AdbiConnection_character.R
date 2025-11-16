#' @rdname dbSendQuery
#' @inheritParams DBI::dbSendStatement
#' @usage NULL
dbSendStatement_AdbiConnection_character <- function(
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
    type = "statement",
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
  "dbSendStatement",
  c("AdbiConnection", "character"),
  dbSendStatement_AdbiConnection_character
)
