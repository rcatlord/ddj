Transforming data with dplyr
================
partrh
2022-09-09

## Learning objectives

  - familiarity with a range of dplyr functions  
  - confident downloading and cleaning Government data  
  - able to conduct simple exploratory data analysis

## Data

We’ll be exploring local area cycling rates in England. The [Active
Lives
Survey](https://www.sportengland.org/research-and-data/data/active-lives)
conducted by Sport England estimates the proportion of adults that cycle
by local authority by frequency and purpose (travel and leisure). The
[data](https://www.gov.uk/government/statistical-data-sets/walking-and-cycling-statistics-cw)
(Table CW0302) are available to download from the Department of
Transport and cover November 2015 to November
    2021.

## Setup

``` r
library(tidyverse) ; library(readODS)
```

    ## Warning: package 'tidyverse' was built under R version 3.6.3

    ## -- Attaching packages --------------------------------------- tidyverse 1.3.1 --

    ## v ggplot2 3.3.6     v purrr   0.3.4
    ## v tibble  3.1.1     v dplyr   1.0.6
    ## v tidyr   1.1.3     v stringr 1.4.0
    ## v readr   1.4.0     v forcats 0.5.1

    ## Warning: package 'tibble' was built under R version 3.6.3

    ## Warning: package 'tidyr' was built under R version 3.6.3

    ## Warning: package 'readr' was built under R version 3.6.3

    ## Warning: package 'purrr' was built under R version 3.6.3

    ## Warning: package 'dplyr' was built under R version 3.6.3

    ## Warning: package 'stringr' was built under R version 3.6.2

    ## Warning: package 'forcats' was built under R version 3.6.3

    ## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

    ## Warning: package 'readODS' was built under R version 3.6.3

## Read data

``` r
raw <- read_ods("data/CW0302.ods", sheet = "CW0302_Any_Purpose", skip = 7)
glimpse(raw)
```

    ## Rows: 1,404
    ## Columns: 11
    ## $ `ONS Code`  <chr> "E92000001", "E92000001", "E92000001", "E92000001", "E1200~
    ## $ `Area name` <chr> "England", "England", "England", "England", "North East", ~
    ## $ Mode        <chr> "Cycling", "Cycling", "Cycling", "Cycling", "Cycling", "Cy~
    ## $ Purpose     <chr> "Any", "Any", "Any", "Any", "Any", "Any", "Any", "Any", "A~
    ## $ Frequency   <chr> "At least once per month", "At least once per week", "At l~
    ## $ `2021`      <dbl> 13.1485852, 9.1461409, 3.9487259, 2.1452496, 9.6932193, 6.~
    ## $ `2020`      <chr> "16.095200000000002", "11.615499999999999", "5.3087", "2.9~
    ## $ `2019`      <chr> "16.05837967367966", "11.220882116484759", "5.320626050823~
    ## $ `2018`      <chr> "16.096599999999999", "11.4848", "5.5048000000000004", "3.~
    ## $ `2017`      <chr> "16.877400000000002", "11.855499999999999", "5.67480000000~
    ## $ `2016`      <chr> "17.1082", "11.903", "5.6702000000000004", "3.371799999999~

``` r
raw <- read_ods("data/CW0302.ods", sheet = "CW0302_Any_Purpose", skip = 7,
                na = c("[note 6]", ""))
glimpse(raw)
```

    ## Rows: 1,404
    ## Columns: 11
    ## $ `ONS Code`  <chr> "E92000001", "E92000001", "E92000001", "E92000001", "E1200~
    ## $ `Area name` <chr> "England", "England", "England", "England", "North East", ~
    ## $ Mode        <chr> "Cycling", "Cycling", "Cycling", "Cycling", "Cycling", "Cy~
    ## $ Purpose     <chr> "Any", "Any", "Any", "Any", "Any", "Any", "Any", "Any", "A~
    ## $ Frequency   <chr> "At least once per month", "At least once per week", "At l~
    ## $ `2021`      <dbl> 13.1485852, 9.1461409, 3.9487259, 2.1452496, 9.6932193, 6.~
    ## $ `2020`      <dbl> 16.0952, 11.6155, 5.3087, 2.9789, 12.5762, 8.8337, 4.3334,~
    ## $ `2019`      <dbl> 16.058380, 11.220882, 5.320626, 3.170456, 12.254710, 8.682~
    ## $ `2018`      <dbl> 16.0966, 11.4848, 5.5048, 3.3369, 13.1044, 9.4183, 4.0836,~
    ## $ `2017`      <dbl> 16.8774, 11.8555, 5.6748, 3.3673, 13.7746, 9.7846, 4.0854,~
    ## $ `2016`      <dbl> 17.1082, 11.9030, 5.6702, 3.3718, 13.8429, 9.9438, 4.5171,~

``` r
raw <- read_ods("data/CW0302.ods", sheet = "CW0302_Any_Purpose", skip = 7) %>%
  mutate(across(everything(), na_if, "[note 6]")) %>% 
  mutate_at(c(7:11), as.numeric)
glimpse(raw)
```

    ## Rows: 1,404
    ## Columns: 11
    ## $ `ONS Code`  <chr> "E92000001", "E92000001", "E92000001", "E92000001", "E1200~
    ## $ `Area name` <chr> "England", "England", "England", "England", "North East", ~
    ## $ Mode        <chr> "Cycling", "Cycling", "Cycling", "Cycling", "Cycling", "Cy~
    ## $ Purpose     <chr> "Any", "Any", "Any", "Any", "Any", "Any", "Any", "Any", "A~
    ## $ Frequency   <chr> "At least once per month", "At least once per week", "At l~
    ## $ `2021`      <dbl> 13.1485852, 9.1461409, 3.9487259, 2.1452496, 9.6932193, 6.~
    ## $ `2020`      <dbl> 16.0952, 11.6155, 5.3087, 2.9789, 12.5762, 8.8337, 4.3334,~
    ## $ `2019`      <dbl> 16.058380, 11.220882, 5.320626, 3.170456, 12.254710, 8.682~
    ## $ `2018`      <dbl> 16.0966, 11.4848, 5.5048, 3.3369, 13.1044, 9.4183, 4.0836,~
    ## $ `2017`      <dbl> 16.8774, 11.8555, 5.6748, 3.3673, 13.7746, 9.7846, 4.0854,~
    ## $ `2016`      <dbl> 17.1082, 11.9030, 5.6702, 3.3718, 13.8429, 9.9438, 4.5171,~

## Format data

``` r
map_dbl(raw, ~sum(is.na(.)))
```

    ##  ONS Code Area name      Mode   Purpose Frequency      2021      2020      2019 
    ##         0         0         0         0         0         0         8        12 
    ##      2018      2017      2016 
    ##        32        32        32

``` r
filter(raw, is.na(`2020`))
```

    ##    ONS Code              Area name    Mode Purpose                 Frequency
    ## 1 E06000061 North Northamptonshire Cycling     Any   At least once per month
    ## 2 E06000061 North Northamptonshire Cycling     Any    At least once per week
    ## 3 E06000061 North Northamptonshire Cycling     Any At least 3 times per week
    ## 4 E06000061 North Northamptonshire Cycling     Any At least 5 times per week
    ## 5 E06000062  West Northamptonshire Cycling     Any   At least once per month
    ## 6 E06000062  West Northamptonshire Cycling     Any    At least once per week
    ## 7 E06000062  West Northamptonshire Cycling     Any At least 3 times per week
    ## 8 E06000062  West Northamptonshire Cycling     Any At least 5 times per week
    ##        2021 2020 2019 2018 2017 2016
    ## 1 9.7398798   NA   NA   NA   NA   NA
    ## 2 6.1512690   NA   NA   NA   NA   NA
    ## 3 2.0794467   NA   NA   NA   NA   NA
    ## 4 1.4468710   NA   NA   NA   NA   NA
    ## 5 8.6567003   NA   NA   NA   NA   NA
    ## 6 5.6671306   NA   NA   NA   NA   NA
    ## 7 1.5093809   NA   NA   NA   NA   NA
    ## 8 0.8030762   NA   NA   NA   NA   NA

## Inspect data

``` r
levels(factor(raw$Frequency))
```

    ## [1] "At least 3 times per week" "At least 5 times per week"
    ## [3] "At least once per month"   "At least once per week"

``` r
unique(pull(raw, Frequency))
```

    ## [1] "At least once per month"   "At least once per week"   
    ## [3] "At least 3 times per week" "At least 5 times per week"

## Tidy data

``` r
lookup <- read_csv("data/Local_Authority_Districts_(December_2020)_Names_and_Codes_in_the_United_Kingdom.csv") %>% 
  pull(LAD20CD)
```

    ## 
    ## -- Column specification --------------------------------------------------------
    ## cols(
    ##   FID = col_double(),
    ##   LAD20CD = col_character(),
    ##   LAD20NM = col_character(),
    ##   LAD20NMW = col_character()
    ## )

``` r
df <- raw %>% 
  select(area_code = `ONS Code`,
         area_name = `Area name`,
         frequency = Frequency,
         6:11) %>% 
  pivot_longer(-c(area_code, area_name, frequency), names_to = "year", values_to = "percent") %>% 
  filter(area_code %in% lookup | area_name == "England")

glimpse(df)
```

    ## Rows: 7,392
    ## Columns: 5
    ## $ area_code <chr> "E92000001", "E92000001", "E92000001", "E92000001", "E920000~
    ## $ area_name <chr> "England", "England", "England", "England", "England", "Engl~
    ## $ frequency <chr> "At least once per month", "At least once per month", "At le~
    ## $ year      <chr> "2021", "2020", "2019", "2018", "2017", "2016", "2021", "202~
    ## $ percent   <dbl> 13.148585, 16.095200, 16.058380, 16.096600, 16.877400, 17.10~

## Explore data

1.  What proportion of adults cycled at least once a week for any
    purpose in England in 2021?

<!-- end list -->

``` r
df %>% 
  filter(area_name == "England",
         frequency == "At least once per week",
         year == 2021)
```

    ## # A tibble: 1 x 5
    ##   area_code area_name frequency              year  percent
    ##   <chr>     <chr>     <chr>                  <chr>   <dbl>
    ## 1 E92000001 England   At least once per week 2021     9.15

2.  How does this cycling rate compare with previous years?

<!-- end list -->

``` r
df %>% 
  filter(area_name == "England",
         frequency == "At least once per week") %>% 
  select(year, percent) %>% 
  arrange(desc(year))
```

    ## # A tibble: 6 x 2
    ##   year  percent
    ##   <chr>   <dbl>
    ## 1 2021     9.15
    ## 2 2020    11.6 
    ## 3 2019    11.2 
    ## 4 2018    11.5 
    ## 5 2017    11.9 
    ## 6 2016    11.9

3.  Which local authority in England had the highest proportion of
    adults cycling at least once a week for any purpose in 2021?

<!-- end list -->

``` r
df %>% 
  filter(area_name != "England",
         frequency == "At least once per week",
         year == 2021) %>% 
  top_n(1, percent)
```

    ## # A tibble: 1 x 5
    ##   area_code area_name frequency              year  percent
    ##   <chr>     <chr>     <chr>                  <chr>   <dbl>
    ## 1 E07000008 Cambridge At least once per week 2021     42.6

``` r
df %>% 
  filter(area_name != "England",
         frequency == "At least once per week",
         year == 2021) %>% 
  top_n(-5, percent)
```

    ## # A tibble: 5 x 5
    ##   area_code area_name frequency              year  percent
    ##   <chr>     <chr>     <chr>                  <chr>   <dbl>
    ## 1 E07000117 Burnley   At least once per week 2021     2.81
    ## 2 E07000120 Hyndburn  At least once per week 2021     3.25
    ## 3 E08000028 Sandwell  At least once per week 2021     3.19
    ## 4 E09000016 Havering  At least once per week 2021     3.22
    ## 5 E06000035 Medway    At least once per week 2021     3.08

4.  How does this cycling rate compare with before the pandemic?

<!-- end list -->

``` r
df %>% 
  filter(area_name == "Cambridge",
         frequency == "At least once per week",
         year %in% c(2019,2021)) %>% 
  select(year, percent) %>% 
  arrange(year) %>% 
  mutate(change = percent - lag(percent))
```

    ## # A tibble: 2 x 3
    ##   year  percent change
    ##   <chr>   <dbl>  <dbl>
    ## 1 2019     55.2   NA  
    ## 2 2021     42.6  -12.6

5.  Which local authority had the largest increase in the proportion of
    adults cycling at least once a week for any purpose in 2021 compared
    with before the pandemic?

<!-- end list -->

``` r
df %>% 
  filter(area_name != "England",
         frequency == "At least once per week",
         year %in% c(2019,2021)) %>% 
  pivot_wider(names_from = year, values_from = percent) %>% 
  mutate(change = `2021` - `2019`) %>% 
  top_n(1, change)
```

    ## # A tibble: 1 x 6
    ##   area_code area_name frequency              `2021` `2019` change
    ##   <chr>     <chr>     <chr>                   <dbl>  <dbl>  <dbl>
    ## 1 E09000019 Islington At least once per week   23.8   16.8   7.02

6.  What percentage of local authorities observed a drop in the
    proportion of adults cycling at least once a week for any purpose in
    2021 compared with before the pandemic?

<!-- end list -->

``` r
df %>% 
  filter(area_name != "England",
         frequency == "At least once per week", 
         year %in% c(2019,2021)) %>% 
  pivot_wider(names_from = year, values_from = percent) %>%
  mutate(change = case_when(`2021` > `2019` ~ "Increase",
                            `2021` < `2019` ~ "Decrease")) %>%
  count(change) %>% 
  mutate(percent = n/sum(n)*100)
```

    ## # A tibble: 3 x 3
    ##   change       n percent
    ##   <chr>    <int>   <dbl>
    ## 1 Decrease   240  78.2  
    ## 2 Increase    66  21.5  
    ## 3 <NA>         1   0.326

7.  How does the proportion of adults cycling at least once a week in
    England differ by purpose between 2021 and
2020?

<!-- end list -->

``` r
leisure <- read_ods("data/CW0302.ods", sheet = "CW0302_Leisure", skip = 7, na = c("[note 6]", "")) %>% 
  filter(`Area name` == "England", Frequency == "At least once per week")

travel <- read_ods("data/CW0302.ods", sheet = "CW0302_Travel", skip = 7, na = c("[note 6]", "")) %>% 
  filter(`Area name` == "England", Frequency == "At least once per week")

bind_rows(leisure, travel) %>% 
  select(purpose = Purpose, 6:7) %>%
  mutate(change = round(`2021`-`2020`,1))
```

    ##   purpose     2021   2020 change
    ## 1 Leisure 5.993489 8.5209   -2.5
    ## 2  Travel 4.555003 5.0996   -0.5

8.  Which age group observed the greatest change in cycling rates in
    England between 2021 and 2020?

<!-- end list -->

``` r
age <- read_ods("data/CW0305.ods", sheet = "CW0305_Age", skip = 7)

age %>%
  filter(Mode == "Cycling", 
         Purpose == "Any",
         Frequency == "At least once per week") %>% 
  select(demographic = Demographic, 6:7) %>%
  mutate(change = round(`2021`-`2020`,1)) %>% 
  arrange(change)
```

    ##   demographic      2021      2020 change
    ## 1    16 to 24  9.839391 13.480230   -3.6
    ## 2    45 to 54 11.756997 15.126249   -3.4
    ## 3    35 to 44 10.832456 13.692075   -2.9
    ## 4    55 to 64  9.607149 12.059411   -2.5
    ## 5    25 to 34 10.056264 12.369078   -2.3
    ## 6    75 to 84  2.871454  4.111465   -1.2
    ## 7    65 to 74  6.854246  7.617528   -0.8
    ## 8 85 and over  1.424197  1.664502   -0.2
