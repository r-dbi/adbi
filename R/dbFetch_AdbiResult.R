#' @rdname DBI
#' @inheritParams DBI::dbFetch
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

  if (is.na(n) && !isTRUE(getOption("adbi.allow_na_fetch"))) {
    stop(
      "`NA` fetching has to be explicitly enabled via the ",
      "`adbi.allow_na_fetch` options.",
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
      meta(res, "ptyp") <- nanoarrow::infer_nanoarrow_ptype(meta(res, "data"))
    }

    ret <- meta(res, "ptyp")

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

#' @rdname DBI
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

get_data_batch <- function(x, what = c("next", "rest")) {

  if (is.null(meta(x, "data"))) {
    return(as.data.frame(meta(x, "ptyp")))
  }

  if (identical(match.arg(what), "rest")) {

    meta(x, "ptyp") <- arrow_ptype(x)

    res <- as.data.frame(meta(x, "data"))

    meta(x, "data") <- NULL
    meta(x, "has_completed") <- TRUE

    return(res)
  }

  as.data.frame(get_next_batch(x))
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