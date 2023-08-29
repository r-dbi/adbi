#' @include adbi-package.R
NULL

#' DBI methods
#'
#' Implementations of pure virtual functions defined in the `DBI` package.
#' @name DBI
NULL

#' Adbi driver
#'
#' TBD.
#'
#' @param driver String-valued driver specification
#'
#' @export
#' @rdname adbi-driver
#' @examples
#' \dontrun{
#' #' library(DBI)
#' adbi::adbi()
#' }
adbi <- function(driver = NA_character_) {

  if (is.na(driver)) {

    drv <- adbcdrivermanager::adbc_driver_monkey()

  } else {

    driver <- strsplit(driver, "::", fixed = TRUE)[[1L]]

    if (length(driver) == 1L) {
      drv <- get(driver, envir = asNamespace(driver))
    } else {
      stopifnot(length(driver) == 2L)
      drv <- get(driver[2L], envir = asNamespace(driver[1L]))
    }
  }

  new("AdbiDriver", driver = drv)
}

#' @rdname DBI
#' @export
setClass(
  "AdbiDriver",
  slots = list(
    driver = "ANY"
  ),
  contains = "DBIDriver"
)

#' @export
DBI::dbCanConnect

#' @export
DBI::Id
