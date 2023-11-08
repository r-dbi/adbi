#' @rdname DBI
#' @inheritParams DBI::dbBind
#' @usage NULL
dbBind_AdbiResult <- function(res, params, ...) {

  if (!isFALSE(meta(res, "immediate"))) {
    stop(
      "A statement containing placeholders should be created using ",
      "`immediate = FALSE`",
      call. = FALSE
    )
  }

  if (length(params) == 0L) {
    stop("Cannot bind zero-length parameter", call. = FALSE)
  }

  if (is.atomic(params)) {
    params <- as.list(params)
  }

  if (is.list(params) && !inherits(params, "data.frame")) {
    params <- as.data.frame(params, fix.empty.names = FALSE)
  }

  if (!isTRUE(meta(res, "prepared"))) {
    adbcdrivermanager::adbc_statement_prepare(res@statement)
    meta(res, "prepared") <- TRUE
  }

  if (is.null(meta(res, "params"))) {

    meta(res, "params") <- nanoarrow::nanoarrow_schema_parse(
      adbcdrivermanager::adbc_statement_get_parameter_schema(res@statement),
      recursive = TRUE
    )
  }

  schema <- meta(res, "params")

  if (!"children" %in% names(schema) || length(schema[["children"]]) == 0L) {
    stop("Unexpected parameter schema.", call. = FALSE)
  }

  schema <- schema[["children"]]

  if (length(params) != length(schema)) {

    stop(
      "Expecting equally many `params` components as placeholders.",
      call. = FALSE
    )
  }

  # TODO placeholders fixed to c("?", "$1", "$name", ":name")

  named_params <- !is.null(names(params)) && all(names(params) != "")
  named_schema <- all(
    names(schema) != as.character(seq_along(schema) - 1L) &
      names(schema) != paste0("$", seq_along(schema))
  )

  if (named_schema) {

    if (named_params) {

      prep_schema_names <- sub("^\\:", "", sub("^\\$", "", names(schema)))

      if (!setequal(prep_schema_names, names(params))) {

        stop(
          "Expecting the same names for `params` components as for ",
          "placeholders.",
          call. = FALSE
        )
      }

    } else {

      stop("Expecting named `params` for named placeholders")
    }

  } else if (named_params) {

    stop("Expecting unnamed `params` for unnamed placeholders")
  }

  adbcdrivermanager::adbc_statement_bind_stream(res@statement, params)

  n_bound <- meta(res, "bound")

  if (is.null(n_bound)) {
    meta(res, "bound") <- 1L
  } else {
    meta(res, "bound") <- n_bound + 1L
  }

  if (!is.null(meta(res, "row_count"))) {
    meta(res, "row_count") <- NULL
  }

  if (!is.null(meta(res, "rows_affected"))) {
    meta(res, "rows_affected") <- NULL
  }

  if (!is.null(meta(res, "ptyp"))) {
    meta(res, "ptyp") <- NULL
  }

  if (!is.null(meta(res, "data"))) {

    if (!isTRUE(meta(res, "has_completed"))) {
      # only triggers if fetched past end
      warning("Not all data has been fetched.", call. = FALSE)
    } else {
      meta(res, "has_completed") <- FALSE
    }

    meta(res, "data")$release()
    meta(res, "data") <- NULL
  }

  if (!is.null(meta(res, "remainder"))) {
    warning("Not all data has been returned.", call. = FALSE)
    meta(res, "remainder") <- NULL
  }

  invisible(res)
}
#' @rdname DBI
#' @export
setMethod("dbBind", "AdbiResult", dbBind_AdbiResult)
