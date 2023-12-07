#' @rdname AdbiDriver-class
#' @inheritParams DBI::dbGetInfo
#' @usage NULL
dbGetInfo_AdbiDriver <- function(dbObj, ...) {
  list(
    driver.version = utils::packageVersion(utils::packageName()),
    client.version = utils::packageVersion("adbcdrivermanager")
  )
}

#' @rdname AdbiDriver-class
#' @export
setMethod("dbGetInfo", "AdbiDriver", dbGetInfo_AdbiDriver)
