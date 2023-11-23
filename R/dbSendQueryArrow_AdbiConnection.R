#' @rdname DBI
#' @param immediate Passing a value `TRUE` is intended for statements containing
#'   no placeholders and `FALSE` otherwise. The default value `NULL` will
#'   inspect the statement for presence of placeholders (will `PREPARE` the
#'   statement)
#' @inheritParams DBI::dbSendQuery
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

#' @rdname DBI
#' @export
setMethod(
  "dbSendQueryArrow",
  "AdbiConnection",
  dbSendQueryArrow_AdbiConnection
)