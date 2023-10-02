#' @rdname DBI
#' @inheritParams DBI::dbBind
#' @usage NULL
dbBind_AdbiResult <- function(res, params, ...) {

  if (!isFALSE(meta(res, "immediate"))) {
    stop("A statement containing placeholders should be created using ",
      "`immediate = FALSE`", call. = FALSE)
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
    # unclear whether all data has been fetched or not
    meta(res, "data")$release()
    meta(res, "data") <- NULL
  }

  if (!is.null(meta(res, "remainder"))) {
    warning("Not all data has been fetched.", call. = FALSE)
    meta(res, "remainder") <- NULL
  }

  invisible(res)
}
#' @rdname DBI
#' @export
setMethod("dbBind", "AdbiResult", dbBind_AdbiResult)
