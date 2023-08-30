
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

This is a basic example which shows you how to solve a common problem:

``` r
library(DBI)

# Create an SQLite connection using the adbcsqlite backend
con <- dbConnect(adbi::adbi("adbcsqlite"), uri = ":memory:")

# Write a table
dbWriteTable(con, "swiss", datasets::swiss)

# Query it
dbGetQuery(con, "SELECT * from swiss WHERE Agriculture < 50")
#>    Fertility Agriculture Examination Education Catholic Infant.Mortality
#> 1       80.2        17.0          15        12     9.96             22.2
#> 2       83.1        45.1           6         9    84.84             22.2
#> 3       92.5        39.7           5         5    93.40             20.2
#> 4       85.8        36.5          12         7    33.77             20.3
#> 5       76.9        43.5          17        15     5.16             20.6
#> 6       76.1        35.3           9         7    90.57             26.6
#> 7       82.9        45.2          16        13    91.38             24.4
#> 8       71.7        34.0          17         8     3.30             20.0
#> 9       55.7        19.4          26        28    12.11             20.2
#> 10      54.3        15.2          31        20     2.15             10.8
#> 11      58.3        26.8          25        19    18.46             20.9
#> 12      65.4        49.5          15         8     6.10             22.5
#> 13      70.4        38.4          26        12     5.62             20.3
#> 14      65.7         7.7          29        11    13.79             20.5
#> 15      72.7        16.7          22        13    11.22             18.9
#> 16      64.4        17.6          35        32    16.92             23.0
#> 17      77.6        37.6          15         7     4.97             20.0
#> 18      67.6        18.7          25         7     8.65             19.5
#> 19      35.0         1.2          37        53    42.34             18.0
#> 20      44.7        46.6          16        29    50.43             18.2
#> 21      42.8        27.7          22        29    58.33             19.3

# Cleanup
dbDisconnect(con)
```
