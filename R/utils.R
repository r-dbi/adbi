meta <- function(x, key) {
  get0(key, envir = x@metadata, inherits = FALSE)
}

`meta<-` <- function(x, key, value) {
  assign(key, value, envir = x@metadata)
  x
}

adbc_is_valid <- function(x, class) {

  if (inherits(x, class)) {

    res <- try(adbcdrivermanager::adbc_xptr_is_valid(x), silent = TRUE)

    if (!inherits(res, "try-error")) {
      return(res)
    }
  }

  FALSE
}

register_result <- function(con, res) {

  meta(con, "results") <- append(meta(con, "results"), res)
  meta(res, "id") <- length(meta(con, "results"))
  meta(res, "con") <- con

  invisible(res)
}

rm_result <- function(res) {

  id <- meta(res, "id")

  con <- meta(res, "con")

  meta(con, "results")[id] <- NULL

  if (isTRUE(meta(con, "disconnect")) && length(meta(con, "results")) == 0L) {
    dbDisconnect(con)
  }

  invisible()
}

split_rows <- function(x) {
  split(x, seq_len(nrow(x)))
}
