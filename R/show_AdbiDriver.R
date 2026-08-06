#' @rdname AdbiDriver-class
#' @inheritParams methods::show
#' @usage NULL
show_AdbiDriver <- function(object) {
  cat("<AdbiDriver>\n")

  if (is.null(object@driver)) {
    cat("  Driver: <driver manager>\n")
  } else if (is.character(object@driver) && dbIsValid(object)) {
    cat("  Driver: ", object@driver, "\n", sep = "")
  } else if (dbIsValid(object)) {
    cat("  Type: <", class(object@driver)[1L], ">\n", sep = "")
  } else {
    cat("  INVALID\n")
  }

  invisible(object)
}

#' @rdname AdbiDriver-class
#' @export
setMethod("show", "AdbiDriver", show_AdbiDriver)
