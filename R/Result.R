#' @include Connection.R
NULL

AdbiResult <- function(connection, statement, immediate = NULL) {

  if (!(is.null(immediate) || identical(immediate, TRUE) ||
      identical(immediate, FALSE))) {

    stop("Expecting `immediate` to be either `TRUE` or `FALSE` (or `NULL` ",
         "in which case the statement is inspected for placeholders)",
         call. = FALSE)
  }

  if (!dbIsValid(connection)) {
    stop("Invalid connection", call. = FALSE)
  }

  con <- connection@connection

  stmt <- adbcdrivermanager::adbc_statement_init(con)

  adbcdrivermanager::adbc_statement_set_sql_query(stmt, statement)

  if (is.null(immediate)) {

    adbcdrivermanager::adbc_statement_prepare(stmt)
    prepared <- TRUE

    schema <- nanoarrow::nanoarrow_schema_parse(
      adbcdrivermanager::adbc_statement_get_parameter_schema(stmt),
      recursive = TRUE
    )

    if ("children" %in% names(schema) && length(schema[["children"]]) > 0L) {
      immediate <- FALSE
    } else {
      immediate <- TRUE
    }

  } else {

    prepared <- FALSE
  }

  meta <- list(
    immediate = immediate,
    prepared = prepared
  )

  res <- new(
    "AdbiResult",
    statement = stmt,
    metadata = list2env(meta, envir = new.env(parent = emptyenv()))
  )

  register_result(connection, res)

  res
}

#' @rdname DBI
#' @export
setClass(
  "AdbiResult",
  contains = "DBIResult",
  slots = list(
    statement = "ANY",
    metadata = "environment"
  )
)
