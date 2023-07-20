#' @keywords internal
#' @aliases adbi-package
"_PACKAGE"

## usethis namespace: start
#' @import DBI
#' @import methods
#' @importFrom adbcdrivermanager adbc_driver
## usethis namespace: end
NULL

setOldClass(c("adbc_driver_monkey", "adbc_driver"))
setOldClass(c("adbc_database_monkey", "adbc_database"))
setOldClass(c("adbc_connection_monkey", "adbc_connection"))
