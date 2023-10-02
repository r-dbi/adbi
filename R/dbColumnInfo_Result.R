#' @rdname DBI
#' @inheritParams DBI::dbColumnInfo
#' @usage NULL
dbColumnInfo_AdbiResult <- function(res, ...) {

  if (is.null(meta(res, "data")) && is.null(meta(res, "row_count"))) {
    execute_statement(res)
  }

  ret <- nanoarrow::nanoarrow_schema_parse(
    meta(res, "data")$get_schema(),
    recursive = TRUE
  )

  if (!"children" %in% names(ret)) {
    stop("Unexpected schema format", call. = FALSE)
  }

  ret <- ret[["children"]]

  data.frame(
    name = names(ret),
    type = vapply(ret, `[[`, character(1L), "type"),
    storage_type = vapply(ret, `[[`, character(1L), "storage_type"),
    row.names = NULL
  )
}

#' @rdname DBI
#' @export
setMethod("dbColumnInfo", "AdbiResult", dbColumnInfo_AdbiResult)
