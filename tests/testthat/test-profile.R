write_adbi_test_driver_manifest <- function(dir, name) {
  driver_path <- getFromNamespace(
    "adbcdrivermanager_shared",
    "adbcdrivermanager"
  )()
  content <- sprintf(
    "
manifest_version = 1

[ADBC]
version = 'v1.1.0'

[Driver]
shared = '%s'
entrypoint = 'AdbcTestVoidDriverInit'
",
    driver_path
  )
  path <- file.path(dir, paste0(name, ".toml"))
  writeLines(content, path)
  path
}

write_adbi_test_profile <- function(dir) {
  manifest_path <- write_adbi_test_driver_manifest(dir, "test_driver")
  profile_path <- file.path(dir, "test_profile.toml")
  writeLines(
    c(
      "profile_version = 1",
      sprintf("driver = '%s'", manifest_path),
      "",
      "[Options]"
    ),
    profile_path
  )
  profile_path
}

test_that("adbi connects using a profile option", {
  dir <- withr::local_tempdir()
  profile_path <- write_adbi_test_profile(dir)

  con <- dbConnect(adbi(), profile = profile_path)
  withr::defer(dbDisconnect(con))

  expect_true(dbIsValid(con))
})

test_that("adbi connects using a profile URI option", {
  dir <- withr::local_tempdir()
  profile_path <- write_adbi_test_profile(dir)

  con <- dbConnect(adbi(), uri = paste0("profile://", profile_path))
  withr::defer(dbDisconnect(con))

  expect_true(dbIsValid(con))
})

test_that("adbi connects using a profile URI driver", {
  dir <- withr::local_tempdir()
  profile_path <- write_adbi_test_profile(dir)

  con <- dbConnect(adbi(paste0("profile://", profile_path)))
  withr::defer(dbDisconnect(con))

  expect_true(dbIsValid(con))
})
