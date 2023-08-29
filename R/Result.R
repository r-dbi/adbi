#' @include Connection.R
NULL

AdbiResult <- function(connection, statement) {

  stopifnot(dbIsValid(connection))

  con <- connection@connection

  stmt <- adbcdrivermanager::adbc_statement_init(con)

  adbcdrivermanager::adbc_statement_set_sql_query(stmt, statement)

  new("AdbiResult",
    statement = stmt
  )
}

#' @rdname DBI
#' @export
setClass(
  "AdbiResult",
  contains = "DBIResult",
  slots = list(
    statement = "ANY"
  )
)
