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

  if (!isTRUE(getOption("adbi.allow_multiple_results", TRUE)) &&
    length(meta(con, "results"))) {

    warning(
      "Open result(s) already exists for this connection and will be ",
      "closed. To enable multiple open results, set ",
      "`options(adbi.allow_multiple_results = TRUE)`."
    )

    clear_results(con)
  }

  meta(con, "results") <- append(meta(con, "results"), res)
  meta(res, "id") <- length(meta(con, "results"))
  meta(res, "con") <- con

  invisible(res)
}

clear_results <- function(con) {

  for (res in meta(con, "results")) {
    dbClearResult(res)
  }

  meta(con, "results") <- list()

  invisible()
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

db_data_type_blob <- function(drv) {

  if (inherits(drv, "adbcsqlite_driver_sqlite")) {
    "BLOB"
  } else if (inherits(drv, "adbcpostgresql_driver_postgresql")) {
    "bytea"
  } else {
    stop(
      "dbDataType for blob objects unknown for type ",
      paste0(class(drv), collapse = ", "),
      call. = FALSE
    )
  }
}
