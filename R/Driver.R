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
    drv <- get(driver, envir = asNamespace(driver))
  }

  new("AdbiDriver", driver = drv)
}

#' @rdname DBI
#' @export
setClass(
  "AdbiDriver",
  slots = list(
    driver = "adbc_driver"
  ),
  contains = "DBIDriver"
)

#' @export
DBI::dbCanConnect

#' @export
DBI::Id
