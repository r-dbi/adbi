#' @rdname DBI
#' @inheritParams DBI::dbWriteTable
#' @param overwrite Allow overwriting the destination table. Cannot be
#'   `TRUE` if `append` is also `TRUE`.
#' @param append Allow appending to the destination table. Cannot be
#'   `TRUE` if `overwrite` is also `TRUE`.
#' @param field.types character vector of named  SQL field types where
#'   the names are the names of new table's columns. If missing, types inferred
#'   with [DBI::dbDataType()]).
#' @param row.names A logical specifying whether the `row.names` should be
#'   output to the output DBMS table; if `TRUE`, an extra field whose name
#'   will be whatever the R identifier `"row.names"` maps to the DBMS (see
#'   [DBI::make.db.names()]). If `NA` will add rows names if
#'   they are characters, otherwise will ignore.
#' @param temporary a logical specifying whether the new table should be
#'   temporary. Its default is `FALSE`.
#' @usage NULL
dbWriteTable_AdbiConnection_character_data.frame <- function(conn, name, value, overwrite = FALSE, append = FALSE, ..., field.types = NULL, row.names = NULL,
  temporary = FALSE) {

  if (is.null(row.names)) {
    row.names <- FALSE
  }

  if ((!is.logical(row.names) && !is.character(row.names)) ||
    length(row.names) != 1L) {

    stop("`row.names` must be a logical scalar or a string")
  } else if (is.character(row.names) || row.names) {
    stop("setting row.names is not supported")
  }

  if (!is.logical(overwrite) || length(overwrite) != 1L || is.na(overwrite)) {
    stop("`overwrite` must be a logical scalar")
  }

  if (!is.logical(append) || length(append) != 1L || is.na(append)) {
    stop("`append` must be a logical scalar")
  }

  if (!is.logical(temporary) || length(temporary) != 1L) {
    stop("`temporary` must be a logical scalar")
  } else if (temporary) {
    stop("temporary tables are not supported")
  }

  if (overwrite && append) {
    stop("overwrite and append cannot both be TRUE")
  }

  if (!is.null(field.types) && !(is.character(field.types) &&
    !is.null(names(field.types)) && !anyDuplicated(names(field.types)))) {

    stop("`field.types` must be a named character vector with unique names, ",
         "or NULL")

  } else if (!is.null(field.types)) {
    stop("specifying field.types is not supported")
  }

  if (append && !is.null(field.types)) {
    stop("Cannot specify `field.types` with `append = TRUE`")
  }

  if (append) {
    mode <- "append"
  } else if (overwrite) {
    mode <- "replace"
  } else {
    mode <- "create"
  }

  stmt <- adbcdrivermanager::adbc_statement_init(
    conn@connection,
    adbc.ingest.target_table = name,
    adbc.ingest.mode = paste0("adbc.ingest.mode.", mode)
  )

  on.exit(adbcdrivermanager::adbc_statement_release(stmt))

  adbcdrivermanager::adbc_statement_bind_stream(stmt, value)
  adbcdrivermanager::adbc_statement_execute_query(stmt)

  invisible(TRUE)
}

#' @rdname DBI
#' @export
setMethod(
  "dbWriteTable",
  c("AdbiConnection", "character", "data.frame"),
  dbWriteTable_AdbiConnection_character_data.frame
)
