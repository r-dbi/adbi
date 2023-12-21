#' Fetch result sets
#'
#' When fetching results using [dbFetch()], the argument `n` can be specified
#' to control chunk size per fetching operation. The default value of `-1`
#' corresponds to retrieving the entire result set at once, while a positive
#' integer will try returning as many rows (as long as `n` does not exceed the
#' available number of rows), in line with standard DBI expectations. As data
#' transfer is mediated by Arrow data structures, which are retrieved as array
#' chunks, the underlying chunk size can be used by passing an `n` value `NA`.
#'
#' @rdname dbFetch
#' @inheritParams DBI::dbFetch
#' @examples
#' if (requireNamespace("adbcsqlite")) {
#'   library(DBI)
#'   con <- dbConnect(adbi::adbi("adbcsqlite"), uri = ":memory:")
#'   dbWriteTable(con, "swiss", swiss)
#'   res <- dbSendQuery(con, "SELECT * from swiss WHERE Agriculture < 30")
#'   dbFetch(res)
#'   dbClearResult(res)
#'   dbDisconnect(con)
#' }
#' @return A `data.frame` with the requested number of rows (or zero rows if
#'   [dbFetch()] is called on a result set with no more remaining rows).
#' @usage NULL
dbFetch_AdbiResult <- function(res, n = -1, ...) {

  if (length(n) == 1L && !is.na(n) && !is.finite(n)) {
    n <- -1
  }

  if (!length(n) == 1L || !is.na(n) && (n < -1 || isTRUE(n != trunc(n)))) {

    stop(
      "Only scalar integer values >= -1 or `NA` are recognized.",
      call. = FALSE
    )
  }

  if (isFALSE(meta(res, "immediate"))) {

    n_bound <- meta(res, "bound")

    if (is.null(n_bound) || n_bound < 1L) {

      stop(
        "A statement created with `immediate = FALSE` should be prepared ",
        "before being executed, typically by a call to `dbBind()`.",
        call. = FALSE
      )
    }
  }

  if (identical(meta(res, "type"), "statement")) {
    warning("Statements are not expected to return results.", call. = FALSE)
    return(data.frame())
  }

  if (is.null(meta(res, "data")) && !isTRUE(meta(res, "has_completed"))) {
    execute_statement(res)
  }

  rem <- meta(res, "remainder")

  if (isTRUE(n == -1)) {

    ret <- get_data_batch(res, "rest")

    if (!is.null(rem)) {
      ret <- rbind(rem, ret)
      meta(res, "remainder") <- NULL
    }

    meta(res, "row_count") <- meta(res, "row_count") + nrow(ret)

    rownames(ret) <- NULL

    return(ret)
  }

  if (is.na(n)) {

    if (is.null(rem)) {
      ret <- get_data_batch(res, "next")
      meta(res, "row_count") <- meta(res, "row_count") + nrow(ret)
      return(ret)
    }

    meta(res, "remainder") <- NULL
    meta(res, "row_count") <- meta(res, "row_count") + nrow(rem)

    rownames(rem) <- NULL

    return(rem)
  }

  if (is.null(rem)) {

    if (is.null(meta(res, "ptyp"))) {
      meta(res, "ptyp") <- arrow_ptype(res)
    }

    ret <- as_data_frame(meta(res, "ptyp"), res@bigint)

  } else {

    ret <- rem
  }

  while (nrow(ret) < n) {

    nxt <- get_data_batch(res, "next")
    ret <- rbind(ret, nxt)

    if (is.null(meta(res, "data"))) {
      break
    }
  }

  if (nrow(ret) <= n) {

    meta(res, "row_count") <- meta(res, "row_count") + nrow(ret)
    meta(res, "remainder") <- NULL

    rownames(ret) <- NULL

    if (nrow(ret) < 0) {
      stopifnot(nrow(get_data_batch(res)) == 0L, dbHasCompleted(res))
    }

    return(ret)
  }

  meta(res, "remainder") <- ret[seq.int(n + 1, nrow(ret)), , drop = FALSE]
  meta(res, "row_count") <- meta(res, "row_count") + n

  ret <- ret[seq_len(n), , drop = FALSE]
  rownames(ret) <- NULL

  ret
}

#' @rdname dbFetch
#' @export
setMethod("dbFetch", "AdbiResult", dbFetch_AdbiResult)

execute_statement <- function(x) {

  stopifnot(
    is.null(meta(x, "data")),
    is.null(meta(x, "row_count"))
  )

  meta(x, "data") <- nanoarrow::nanoarrow_allocate_array_stream()
  meta(x, "rows_affected") <- adbcdrivermanager::adbc_statement_execute_query(
    x@statement,
    stream = meta(x, "data")
  )
  meta(x, "row_count") <- 0L

  invisible(x)
}

split_dash <- function(x) {
  stopifnot(is.character(x), length(x) == 1L)
  strsplit(x, "-", fixed = TRUE)[[1L]]
}

bigint_type <- function(x) {
  split_dash(x)[1L]
}

bigint_mode <- function(x) {

  mode <- split_dash(x)[2L]

  if (is.na(mode)) {
    "classic"
  } else {
    mode
  }
}

converter_to <- function(to) {

  bint_ptype <- switch(
    bigint_type(to),
    integer = integer(),
    numeric = numeric(),
    character = character(),
    integer64 = bit64::integer64(),
    stop("Unexpected value for `to` (type).", call. = FALSE)
  )

  function(schema, ptype) {

    if (!inherits(schema, "nanoarrow_schema")) {
      schema <- nanoarrow::infer_nanoarrow_schema(schema)
    }

    cols <- nanoarrow::nanoarrow_schema_parse(schema, recursive = TRUE)
    cols <- cols[["children"]]

    typs <- vapply(cols, `[[`, character(1L), "type")
    bint <- typs == "int64"

    ptype[bint] <- list(bint_ptype)

    ptype
  }
}

conversion_warn_handler <- function(to) {

  handler <- switch(
    bigint_mode(to),
    classic = function(class) {
      class <- force(class)
      function(w) if (inherits(w, class)) tryInvokeRestart("muffleWarning")
    },
    strict = function(class) {
      class <- force(class)
      function(w) if (inherits(w, class)) stop(w)
    },
    stop("Unexpected value for `to` (mode).", call. = FALSE)
  )

  function(expr) {
    withCallingHandlers(
      expr,
      warning = handler("nanoarrow_warning_lossy_conversion")
    )
  }
}

as_data_frame <- function(x, bigint) {

  to <- converter_to(bigint)
  warn <- conversion_warn_handler(bigint)

  if (inherits(x, "nanoarrow_array_stream")) {
    on.exit(x$release())
    warn(nanoarrow::convert_array_stream(x, to))
  } else if (inherits(x, "nanoarrow_array")) {
    warn(nanoarrow::convert_array(x, to))
  } else {
    stop("Unexpected conversion of type ", class(x), ".", call. = FALSE)
  }
}

get_data_batch <- function(x, what = c("next", "rest")) {

  if (is.null(meta(x, "data"))) {

    res <- meta(x, "ptyp")

  } else if (identical(match.arg(what), "rest")) {

    meta(x, "ptyp") <- arrow_ptype(x)

    res <- meta(x, "data")

    meta(x, "data") <- NULL
    meta(x, "has_completed") <- TRUE

  } else {

    res <- get_next_batch(x)
  }

  as_data_frame(res, x@bigint)
}

get_next_batch <- function(x) {

  if (is.null(meta(x, "data"))) {

    if (!isTRUE(meta(x, "has_completed"))) {

      stop(
        "Result has been released but not marked as completed.",
        call. = FALSE
      )
    }

    return(meta(x, "ptyp"))
  }

  res <- meta(x, "data")$get_next()

  if (is.null(res)) {

    meta(x, "ptyp") <- arrow_ptype(x)
    meta(x, "data")$release()
    meta(x, "data") <- NULL
    meta(x, "has_completed") <- TRUE

    return(meta(x, "ptyp"))
  }

  res
}

arrow_ptype <- function(x) {

  if (is.null(meta(x, "data"))) {
    stop("Cannot infer ptype from released result.", call. = FALSE)
  }

  nanoarrow::nanoarrow_array_init(
    nanoarrow::infer_nanoarrow_schema(meta(x, "data"))
  )
}

collect_array_stream <- function(x) {

  if (is.null(meta(x, "data"))) {

    if (!isTRUE(meta(x, "has_completed"))) {

      stop(
        "Result has been released but not marked as completed.",
        call. = FALSE
      )
    }

    return(meta(x, "ptyp"))
  }

  ret <- nanoarrow::collect_array_stream(meta(x, "data"))

  meta(x, "ptyp") <- list(arrow_ptype(x))

  meta(x, "data")$release()
  meta(x, "data") <- NULL
  meta(x, "has_completed") <- TRUE

  if (length(ret)) {
    return(ret)
  }

  meta(x, "ptyp")
}
