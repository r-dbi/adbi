test_that("fetch result with arbitrary chunk size", {

  withr::local_options(adbi.allow_na_fetch = TRUE)

  res <- new_result("foo", TRUE, FALSE, "query", "")
  dat <- data.frame(x = 1:15)

  meta(res, "data") <- nanoarrow::basic_array_stream(
    split(dat, rep(1:3, each = 5))
  )

  n_seq <- c(2, NA, 7, -1)
  ret <- vector("list", length(n_seq))

  for (i in seq_along(n_seq)) {
    ret[[i]] <- dbFetch(res, n_seq[i])
  }

  expect_identical(vapply(ret, nrow, integer(1L)), c(2L, 3L, 7L, 3L))
  expect_equal(dat, do.call(rbind, ret), check.attributes = FALSE)
})
