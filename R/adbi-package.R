#' @keywords internal
#' @aliases adbi-package
"_PACKAGE"

## usethis namespace: start
#' @import DBI
#' @import methods
#' @importFrom adbcdrivermanager adbc_driver
## usethis namespace: end
NULL

adbc_is_valid <- function(x, class) {

  if (inherits(x, class)) {

    res <- try(adbcdrivermanager::adbc_xptr_is_valid(x), silent = TRUE)

    if (!inherits(res, "try-error")) {
      return(res)
    }
  }

  FALSE
}
