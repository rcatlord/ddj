#' ---
#' title: "Transforming data with dplyr"
#' output: github_document
#' ---
#'
#' ## Learning objectives
#' - familiarity with a range of dplyr functions  
#' - confident downloading and cleaning Government data  
#' - able to conduct simple exploratory data analysis
#'
#' ## Data
#' We'll be exploring local area cycling rates in England. 
#' The [Active Lives Survey](https://www.sportengland.org/research-and-data/data/active-lives) conducted by Sport England estimates the proportion of adults that cycle by local authority by frequency and purpose (travel and leisure). 
#' The [data](https://www.gov.uk/government/statistical-data-sets/walking-and-cycling-statistics-cw) (Table CW0302) are available to download from the Department of Transport and cover November 2015 to November 2021.
#'
#' ## Setup
#' 
library(tidyverse) ; library(readODS)

#' 
#' ## Read data
#' 
raw <- read_ods("data/CW0302.ods", sheet = "CW0302_Any_Purpose", skip = 7)
glimpse(raw)

raw <- read_ods("data/CW0302.ods", sheet = "CW0302_Any_Purpose", skip = 7,
                na = c("[note 6]", ""))
glimpse(raw)

raw <- read_ods("data/CW0302.ods", sheet = "CW0302_Any_Purpose", skip = 7) %>%
  mutate(across(everything(), na_if, "[note 6]")) %>% 
  mutate_at(c(7:11), as.numeric)
glimpse(raw)

#' 
#' ## Format data
#' 
map_dbl(raw, ~sum(is.na(.)))
filter(raw, is.na(`2020`))

#' 
#' ## Inspect data
#' 
levels(factor(raw$Frequency))
unique(pull(raw, Frequency))

#' 
#' ## Tidy data
#' 

lookup <- read_csv("data/Local_Authority_Districts_(December_2020)_Names_and_Codes_in_the_United_Kingdom.csv") %>% 
  pull(LAD20CD)

df <- raw %>% 
  select(area_code = `ONS Code`,
         area_name = `Area name`,
         frequency = Frequency,
         6:11) %>% 
  pivot_longer(-c(area_code, area_name, frequency), names_to = "year", values_to = "percent") %>% 
  filter(area_code %in% lookup | area_name == "England")

glimpse(df)

#' ## Explore data
#' 
#' 1.  What proportion of adults cycled at least once a week for any purpose in England in 2021?
df %>% 
  filter(area_name == "England",
         frequency == "At least once per week",
         year == 2021)

#'
#' 2.  How does this cycling rate compare with previous years?
df %>% 
  filter(area_name == "England",
         frequency == "At least once per week") %>% 
  select(year, percent) %>% 
  arrange(desc(year))


#'
#' 3.  Which local authority in England had the highest proportion of adults cycling at least once a week for any purpose in 2021?

df %>% 
  filter(area_name != "England",
         frequency == "At least once per week",
         year == 2021) %>% 
  top_n(1, percent)

df %>% 
  filter(area_name != "England",
         frequency == "At least once per week",
         year == 2021) %>% 
  top_n(-5, percent)

#'
#' 4.  How does this cycling rate compare with before the pandemic?

df %>% 
  filter(area_name == "Cambridge",
         frequency == "At least once per week",
         year %in% c(2019,2021)) %>% 
  select(year, percent) %>% 
  arrange(year) %>% 
  mutate(change = percent - lag(percent))

#'
#' 5.  Which local authority had the largest increase in the proportion of adults cycling at least once a week for any purpose in 2021 compared with before the pandemic?

df %>% 
  filter(area_name != "England",
         frequency == "At least once per week",
         year %in% c(2019,2021)) %>% 
  pivot_wider(names_from = year, values_from = percent) %>% 
  mutate(change = `2021` - `2019`) %>% 
  top_n(1, change)
  
  
#'
#' 6.  What percentage of local authorities observed a drop in the proportion of adults cycling at least once a week for any purpose in 2021 compared with before the pandemic?

df %>% 
  filter(area_name != "England",
         frequency == "At least once per week", 
         year %in% c(2019,2021)) %>% 
  pivot_wider(names_from = year, values_from = percent) %>%
  mutate(change = case_when(`2021` > `2019` ~ "Increase",
                            `2021` < `2019` ~ "Decrease")) %>%
  count(change) %>% 
  mutate(percent = n/sum(n)*100)

#'
#' 7.  How does the proportion of adults cycling at least once a week in England differ by purpose between 2021 and 2020?

leisure <- read_ods("data/CW0302.ods", sheet = "CW0302_Leisure", skip = 7, na = c("[note 6]", "")) %>% 
  filter(`Area name` == "England", Frequency == "At least once per week")

travel <- read_ods("data/CW0302.ods", sheet = "CW0302_Travel", skip = 7, na = c("[note 6]", "")) %>% 
  filter(`Area name` == "England", Frequency == "At least once per week")

bind_rows(leisure, travel) %>% 
  select(purpose = Purpose, 6:7) %>%
  mutate(change = round(`2021`-`2020`,1))

#'
#' 8.  Which age group observed the greatest change in cycling rates in England between 2021 and 2020?

age <- read_ods("data/CW0305.ods", sheet = "CW0305_Age", skip = 7)

age %>%
  filter(Mode == "Cycling", 
         Purpose == "Any",
         Frequency == "At least once per week") %>% 
  select(demographic = Demographic, 6:7) %>%
  mutate(change = round(`2021`-`2020`,1)) %>% 
  arrange(change)
