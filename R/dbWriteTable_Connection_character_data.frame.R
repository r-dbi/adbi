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
dbWriteTable_KazamConnection_character_data.frame <- function(conn, name, value, overwrite = FALSE, append = FALSE, ...,
                                                              field.types = NULL, row.names = NULL, temporary = FALSE) {
  # TODO: Implement better ingestion
  if (is.null(row.names)) row.names <- FALSE
  if ((!is.logical(row.names) && !is.character(row.names)) || length(row.names) != 1L) {
    stop("`row.names` must be a logical scalar or a string")
  }
  if (!is.logical(overwrite) || length(overwrite) != 1L || is.na(overwrite)) {
    stop("`overwrite` must be a logical scalar")
  }
  if (!is.logical(append) || length(append) != 1L || is.na(append)) {
    stop("`append` must be a logical scalar")
  }
  if (!is.logical(temporary) || length(temporary) != 1L) {
    stop("`temporary` must be a logical scalar")
  }
  if (overwrite && append) {
    stop("overwrite and append cannot both be TRUE")
  }
  if (!is.null(field.types) && !(is.character(field.types) && !is.null(names(field.types)) && !anyDuplicated(names(field.types)))) {
    stop("`field.types` must be a named character vector with unique names, or NULL")
  }
  if (append && !is.null(field.types)) {
    stop("Cannot specify `field.types` with `append = TRUE`")
  }

  if (overwrite) {
    tryCatch(
      dbRemoveTable(conn, name),
      error = function(e) {}
    )
  }

  value <- sqlRownamesToColumn(value, row.names)

  if (!append || overwrite) {
    if (is.null(field.types)) {
      combined_field_types <- lapply(value, dbDataType, dbObj = conn)
    } else {
      combined_field_types <- rep("", length(value))
      names(combined_field_types) <- names(value)
      field_types_idx <- match(names(field.types), names(combined_field_types))
      stopifnot(!any(is.na(field_types_idx)))
      combined_field_types[field_types_idx] <- field.types
      values_idx <- setdiff(seq_along(value), field_types_idx)
      combined_field_types[values_idx] <- lapply(value[values_idx], dbDataType, dbObj = conn)
    }

    dbCreateTable(
      conn = conn,
      name = name,
      fields = combined_field_types,
      temporary = temporary
    )
  }

  if (nrow(value) > 0) {
    dbAppendTable(conn, name, value)
  }

  invisible(TRUE)
}
#' @rdname DBI
#' @export
setMethod("dbWriteTable", c("KazamConnection", "character", "data.frame"), dbWriteTable_KazamConnection_character_data.frame)
