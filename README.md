
<!-- README.md is generated from README.Rmd. Please edit that file -->

# adbi

<!-- badges: start -->

[![rcc](https://github.com/r-dbi/adbi/workflows/rcc/badge.svg)](https://github.com/r-dbi/adbi/actions)
[![Codecov test
coverage](https://codecov.io/gh/r-dbi/adbi/branch/main/graph/badge.svg)](https://codecov.io/gh/r-dbi/adbi?branch=main)
<!-- badges: end -->

Bringing [arrow-adbc](https://github.com/apache/arrow-adbc) to R via
[DBI](https://github.com/r-dbi), adbi aims to provide DBI-compliant
database access.

## Installation

You can install the development version of adbi from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("r-dbi/adbi")
```

## Example

The `data.frame` API of DBI is supported.

``` r
library(DBI)

# Create an SQLite connection using the adbcsqlite backend
con <- dbConnect(adbi::adbi("adbcsqlite"), uri = ":memory:")

# Write a table
dbWriteTable(con, "swiss", datasets::swiss)

# Query it
dbGetQuery(con, "SELECT * from swiss WHERE Agriculture < 40")
#>    Fertility Agriculture Examination Education Catholic Infant.Mortality
#> 1       80.2        17.0          15        12     9.96             22.2
#> 2       92.5        39.7           5         5    93.40             20.2
#> 3       85.8        36.5          12         7    33.77             20.3
#> 4       76.1        35.3           9         7    90.57             26.6
#> 5       71.7        34.0          17         8     3.30             20.0
#> 6       55.7        19.4          26        28    12.11             20.2
#> 7       54.3        15.2          31        20     2.15             10.8
#> 8       58.3        26.8          25        19    18.46             20.9
#> 9       70.4        38.4          26        12     5.62             20.3
#> 10      65.7         7.7          29        11    13.79             20.5
#> 11      72.7        16.7          22        13    11.22             18.9
#> 12      64.4        17.6          35        32    16.92             23.0
#> 13      77.6        37.6          15         7     4.97             20.0
#> 14      67.6        18.7          25         7     8.65             19.5
#> 15      35.0         1.2          37        53    42.34             18.0
#> 16      42.8        27.7          22        29    58.33             19.3

# Prepared statements
res <- dbSendQuery(con, "SELECT * from swiss WHERE Agriculture < ?")

dbBind(res, 30)
dbFetch(res)
#>    Fertility Agriculture Examination Education Catholic Infant.Mortality
#> 1       80.2        17.0          15        12     9.96             22.2
#> 2       55.7        19.4          26        28    12.11             20.2
#> 3       54.3        15.2          31        20     2.15             10.8
#> 4       58.3        26.8          25        19    18.46             20.9
#> 5       65.7         7.7          29        11    13.79             20.5
#> 6       72.7        16.7          22        13    11.22             18.9
#> 7       64.4        17.6          35        32    16.92             23.0
#> 8       67.6        18.7          25         7     8.65             19.5
#> 9       35.0         1.2          37        53    42.34             18.0
#> 10      42.8        27.7          22        29    58.33             19.3

dbBind(res, 20)
dbFetch(res)
#>   Fertility Agriculture Examination Education Catholic Infant.Mortality
#> 1      80.2        17.0          15        12     9.96             22.2
#> 2      55.7        19.4          26        28    12.11             20.2
#> 3      54.3        15.2          31        20     2.15             10.8
#> 4      65.7         7.7          29        11    13.79             20.5
#> 5      72.7        16.7          22        13    11.22             18.9
#> 6      64.4        17.6          35        32    16.92             23.0
#> 7      67.6        18.7          25         7     8.65             19.5
#> 8      35.0         1.2          37        53    42.34             18.0

# Cleanup
dbClearResult(res)
```

More interestingly, the recent arrow-extension API of DBI is supported
as well.

``` r
# Queries
dbGetQueryArrow(con, "SELECT * from swiss WHERE Agriculture < 40")
#> <nanoarrow_array struct[16]>
#>  $ length    : int 16
#>  $ null_count: int 0
#>  $ offset    : int 0
#>  $ buffers   :List of 1
#>   ..$ :<nanoarrow_buffer validity<bool>[0][0 b]> ``
#>  $ children  :List of 6
#>   ..$ Fertility       :<nanoarrow_array double[16]>
#>   .. ..$ length    : int 16
#>   .. ..$ null_count: int -1
#>   .. ..$ offset    : int 0
#>   .. ..$ buffers   :List of 2
#>   .. .. ..$ :<nanoarrow_buffer validity<bool>[16][2 b]> `TRUE TRUE TRUE TRUE...`
#>   .. .. ..$ :<nanoarrow_buffer data<double>[16][128 b]> `80.2 92.5 85.8 76.1...`
#>   .. ..$ dictionary: NULL
#>   .. ..$ children  : list()
#>   ..$ Agriculture     :<nanoarrow_array double[16]>
#>   .. ..$ length    : int 16
#>   .. ..$ null_count: int -1
#>   .. ..$ offset    : int 0
#>   .. ..$ buffers   :List of 2
#>   .. .. ..$ :<nanoarrow_buffer validity<bool>[16][2 b]> `TRUE TRUE TRUE TRUE...`
#>   .. .. ..$ :<nanoarrow_buffer data<double>[16][128 b]> `17.0 39.7 36.5 35.3...`
#>   .. ..$ dictionary: NULL
#>   .. ..$ children  : list()
#>   ..$ Examination     :<nanoarrow_array int64[16]>
#>   .. ..$ length    : int 16
#>   .. ..$ null_count: int -1
#>   .. ..$ offset    : int 0
#>   .. ..$ buffers   :List of 2
#>   .. .. ..$ :<nanoarrow_buffer validity<bool>[16][2 b]> `TRUE TRUE TRUE TRUE...`
#>   .. .. ..$ :<nanoarrow_buffer data<int64>[16][128 b]> `15 5 12 9 17 26 31 2...`
#>   .. ..$ dictionary: NULL
#>   .. ..$ children  : list()
#>   ..$ Education       :<nanoarrow_array int64[16]>
#>   .. ..$ length    : int 16
#>   .. ..$ null_count: int -1
#>   .. ..$ offset    : int 0
#>   .. ..$ buffers   :List of 2
#>   .. .. ..$ :<nanoarrow_buffer validity<bool>[16][2 b]> `TRUE TRUE TRUE TRUE...`
#>   .. .. ..$ :<nanoarrow_buffer data<int64>[16][128 b]> `12 5 7 7 8 28 20 19 ...`
#>   .. ..$ dictionary: NULL
#>   .. ..$ children  : list()
#>   ..$ Catholic        :<nanoarrow_array double[16]>
#>   .. ..$ length    : int 16
#>   .. ..$ null_count: int -1
#>   .. ..$ offset    : int 0
#>   .. ..$ buffers   :List of 2
#>   .. .. ..$ :<nanoarrow_buffer validity<bool>[16][2 b]> `TRUE TRUE TRUE TRUE...`
#>   .. .. ..$ :<nanoarrow_buffer data<double>[16][128 b]> `9.96 93.40 33.77 90...`
#>   .. ..$ dictionary: NULL
#>   .. ..$ children  : list()
#>   ..$ Infant.Mortality:<nanoarrow_array double[16]>
#>   .. ..$ length    : int 16
#>   .. ..$ null_count: int -1
#>   .. ..$ offset    : int 0
#>   .. ..$ buffers   :List of 2
#>   .. .. ..$ :<nanoarrow_buffer validity<bool>[16][2 b]> `TRUE TRUE TRUE TRUE...`
#>   .. .. ..$ :<nanoarrow_buffer data<double>[16][128 b]> `22.2 20.2 20.3 26.6...`
#>   .. ..$ dictionary: NULL
#>   .. ..$ children  : list()
#>  $ dictionary: NULL

# Prepared statements
res <- dbSendQueryArrow(con, "SELECT * from swiss WHERE Agriculture < ?")

dbBind(res, 30)

while (!dbHasCompleted(res)) {
  print(dbFetchArrow(res))
}
#> <nanoarrow_array struct[10]>
#>  $ length    : int 10
#>  $ null_count: int 0
#>  $ offset    : int 0
#>  $ buffers   :List of 1
#>   ..$ :<nanoarrow_buffer validity<bool>[0][0 b]> ``
#>  $ children  :List of 6
#>   ..$ Fertility       :<nanoarrow_array double[10]>
#>   .. ..$ length    : int 10
#>   .. ..$ null_count: int -1
#>   .. ..$ offset    : int 0
#>   .. ..$ buffers   :List of 2
#>   .. .. ..$ :<nanoarrow_buffer validity<bool>[16][2 b]> `TRUE TRUE TRUE TRUE...`
#>   .. .. ..$ :<nanoarrow_buffer data<double>[10][80 b]> `80.2 55.7 54.3 58.3 ...`
#>   .. ..$ dictionary: NULL
#>   .. ..$ children  : list()
#>   ..$ Agriculture     :<nanoarrow_array double[10]>
#>   .. ..$ length    : int 10
#>   .. ..$ null_count: int -1
#>   .. ..$ offset    : int 0
#>   .. ..$ buffers   :List of 2
#>   .. .. ..$ :<nanoarrow_buffer validity<bool>[16][2 b]> `TRUE TRUE TRUE TRUE...`
#>   .. .. ..$ :<nanoarrow_buffer data<double>[10][80 b]> `17.0 19.4 15.2 26.8 ...`
#>   .. ..$ dictionary: NULL
#>   .. ..$ children  : list()
#>   ..$ Examination     :<nanoarrow_array int64[10]>
#>   .. ..$ length    : int 10
#>   .. ..$ null_count: int -1
#>   .. ..$ offset    : int 0
#>   .. ..$ buffers   :List of 2
#>   .. .. ..$ :<nanoarrow_buffer validity<bool>[16][2 b]> `TRUE TRUE TRUE TRUE...`
#>   .. .. ..$ :<nanoarrow_buffer data<int64>[10][80 b]> `15 26 31 25 29 22 35 ...`
#>   .. ..$ dictionary: NULL
#>   .. ..$ children  : list()
#>   ..$ Education       :<nanoarrow_array int64[10]>
#>   .. ..$ length    : int 10
#>   .. ..$ null_count: int -1
#>   .. ..$ offset    : int 0
#>   .. ..$ buffers   :List of 2
#>   .. .. ..$ :<nanoarrow_buffer validity<bool>[16][2 b]> `TRUE TRUE TRUE TRUE...`
#>   .. .. ..$ :<nanoarrow_buffer data<int64>[10][80 b]> `12 28 20 19 11 13 32 ...`
#>   .. ..$ dictionary: NULL
#>   .. ..$ children  : list()
#>   ..$ Catholic        :<nanoarrow_array double[10]>
#>   .. ..$ length    : int 10
#>   .. ..$ null_count: int -1
#>   .. ..$ offset    : int 0
#>   .. ..$ buffers   :List of 2
#>   .. .. ..$ :<nanoarrow_buffer validity<bool>[16][2 b]> `TRUE TRUE TRUE TRUE...`
#>   .. .. ..$ :<nanoarrow_buffer data<double>[10][80 b]> `9.96 12.11 2.15 18.4...`
#>   .. ..$ dictionary: NULL
#>   .. ..$ children  : list()
#>   ..$ Infant.Mortality:<nanoarrow_array double[10]>
#>   .. ..$ length    : int 10
#>   .. ..$ null_count: int -1
#>   .. ..$ offset    : int 0
#>   .. ..$ buffers   :List of 2
#>   .. .. ..$ :<nanoarrow_buffer validity<bool>[16][2 b]> `TRUE TRUE TRUE TRUE...`
#>   .. .. ..$ :<nanoarrow_buffer data<double>[10][80 b]> `22.2 20.2 10.8 20.9 ...`
#>   .. ..$ dictionary: NULL
#>   .. ..$ children  : list()
#>  $ dictionary: NULL
#> [1] Fertility        Agriculture      Examination      Education       
#> [5] Catholic         Infant.Mortality
#> <0 rows> (or 0-length row.names)

dbBind(res, 20)

while(!dbHasCompleted(res)) {
  print(dbFetchArrow(res))
}

# Cleanup
dbClearResult(res)
dbDisconnect(con)
```
