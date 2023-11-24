#' @include AdbiConnection.R
NULL

AdbiResult <- function(connection, statement, immediate = NULL,
                       type = c("query", "statement"), bigint = NULL) {

  init_result(connection, statement, "AdbiResult", immediate, type, bigint)
}

init_result <- function(connection, statement, class, immediate = NULL,
                        type = c("query", "statement"), bigint = NULL) {

  if (!(is.null(immediate) || identical(immediate, TRUE) ||
    identical(immediate, FALSE))) {

    stop("Expecting `immediate` to be either `TRUE` or `FALSE` (or `NULL` ",
      "in which case the statement is inspected for placeholders)",
      call. = FALSE)
  }

  if (!dbIsValid(connection)) {
    stop("Invalid connection", call. = FALSE)
  }

  if (!length(statement) == 1L || is.na(statement)) {
    stop("Expecting a non-NA string as `statement`.", call. = FALSE)
  }

  con <- connection@connection

  stmt <- adbcdrivermanager::adbc_statement_init(con)

  adbcdrivermanager::adbc_statement_set_sql_query(
    stmt,
    as.character(statement)
  )

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
    schema <- NULL
  }

  if (is.null(bigint)) {
    bigint <- connection@bigint
  }

  res <- new_result(stmt, immediate, prepared, match.arg(type), statement,
    class, bigint)

  register_result(connection, res)

  meta(res, "params") <- schema

  res
}

new_result <- function(statement, immediate, prepared, type, sql,
                       class = "AdbiResult", bigint = NULL) {

  meta <- list(
    immediate = immediate,
    prepared = prepared,
    type = type,
    sql = sql,
    has_completed = switch(type, statement = TRUE, query = FALSE)
  )

  new(
    class,
    statement = statement,
    metadata = list2env(meta, envir = new.env(parent = emptyenv())),
    bigint = resolve_bigint(bigint)
  )
}

#' @rdname DBI
#' @export
setClass(
  "AdbiResult",
  contains = "DBIResult",
  slots = list(
    statement = "ANY",
    metadata = "environment",
    bigint = "character"
  )
)
