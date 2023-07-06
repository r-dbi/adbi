if (identical(Sys.getenv("NOT_CRAN"), "true") && packageVersion("DBItest") >= "1.7.2") {
  DBItest::test_all()
}
