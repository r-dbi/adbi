#' @rdname AdbiResult-class
#' @inheritParams methods::show
#' @usage NULL
show_AdbiResult <- function(object) {

  cat("<AdbiResult>\n")

  if (dbIsValid(object)) {

    cat("  Immediate: ", meta(object, "immediate"), "\n", sep = "")
    cat("  Prepared: ", meta(object, "prepared"), "\n", sep = "")
    cat("  Type: ", meta(object, "type"), "\n", sep = "")

  } else {

    cat("  CLEARED\n")
  }
}

#' @rdname AdbiResult-class
#' @export
setMethod("show", "AdbiResult", show_AdbiResult)
