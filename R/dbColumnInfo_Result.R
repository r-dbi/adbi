#' @rdname DBI
#' @inheritParams DBI::dbColumnInfo
#' @usage NULL
dbColumnInfo_AdbiResult <- function(res, ...) {

  if (is.null(meta(res, "schema"))) {

    if (is.null(meta(res, "data"))) {

      stream <- execute_statement(res)
      meta(res, "data") <- stream

    } else {
      stream <- meta(res, "data")
    }

    schema <- stream$get_schema()
    meta(res, "schema") <- schema

  } else {

    schema <- meta(res, "schema")
  }

  ret <- nanoarrow::nanoarrow_schema_parse(schema, recursive = TRUE)

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
