#' @rdname AdbiConnection-class
#' @param immediate Passing a value `TRUE` is intended for statements containing
#'   no placeholders and `FALSE` otherwise. The default value `NULL` will
#'   inspect the statement for presence of placeholders (will `PREPARE` the
#'   statement)
#' @inheritParams DBI::dbSendQuery
#' @usage NULL
dbSendQuery_AdbiConnection_character <- function(conn, statement, ...,
    params = NULL, immediate = NULL) {

  if (!is.null(params)) {
    immediate <- FALSE
  }

  res <- AdbiResult(
    connection = conn,
    statement = statement,
    immediate = immediate,
    type = "query",
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

#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbSendQuery",
  c("AdbiConnection", "character"),
  dbSendQuery_AdbiConnection_character
)
