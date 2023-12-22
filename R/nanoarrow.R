#' @importFrom nanoarrow infer_nanoarrow_schema
#' @export
infer_nanoarrow_schema.AsIs <- function(x, ...) {
  oldClass(x) <- oldClass(x)[-1]
  infer_nanoarrow_schema(x)
}

#' @export
infer_nanoarrow_schema.list <- function(x, ...) {

  is_raw <- vapply(x, is.raw, logical(1))

  if (!all(is_raw)) {
    stop("Only lists of raw vectors are currently supported", call. = FALSE)
  }

  if (length(x) > 0 && sum(lengths(x)) > .Machine$integer.max) {
    nanoarrow::na_large_binary()
  } else {
    nanoarrow::na_binary()
  }
}
