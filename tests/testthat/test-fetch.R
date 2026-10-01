test_that("fetch result with arbitrary chunk size", {
  res <- new_result("foo", TRUE, FALSE, "query", "")
  dat <- data.frame(x = 1:15)

  meta(res, "data") <- nanoarrow::basic_array_stream(
    split(dat, rep(1:3, each = 5))
  )

  n_seq <- c(2, NA, 7, -1, NA)
  ret <- vector("list", length(n_seq))

  for (i in seq_along(n_seq)) {
    ret[[i]] <- dbFetch(res, n_seq[i])
  }

  expect_identical(vapply(ret, nrow, integer(1L)), c(2L, 3L, 7L, 3L, 0L))
  expect_equal(dat, do.call(rbind, ret), check.attributes = FALSE)
})

test_that("strict bigint modes fail with an error rather than a warning", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")
  withr::defer(dbDisconnect(con))

  expect_error(
    suppressWarnings(dbGetQuery(con, "SELECT 10000000000 AS a")),
    "outside integer range"
  )
  expect_error(
    suppressWarnings(
      dbGetQuery(
        con,
        "SELECT 1234567890123456789 AS a",
        bigint = "numeric-strict"
      )
    ),
    "loss of precision"
  )
})
