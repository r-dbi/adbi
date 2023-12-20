#' @rdname AdbiResultArrow-class
#' @inheritParams methods::show
#' @usage NULL
show_AdbiResultArrow <- function(object) {

  cat("<AdbiResultArrow>\n")

  if (dbIsValid(object)) {

    cat("  Immediate: ", meta(object, "immediate"), "\n", sep = "")
    cat("  Prepared: ", meta(object, "prepared"), "\n", sep = "")
    cat("  Type: ", meta(object, "type"), "\n", sep = "")

  } else {

    cat("  CLEARED\n")
  }
}

#' @rdname AdbiResultArrow-class
#' @export
setMethod("show", "AdbiResultArrow", show_AdbiResultArrow)
