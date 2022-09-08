## Baby names in England and Wales, 1996-2020 ##

# Source: Office of National Statistics 
# Publisher URL: https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/livebirths/datasets/babynamesinenglandandwalesfrom1996
# License: Open Government License v3.0

library(tidyverse) ; library(httr) ; library(readxl)

tmp <- tempfile(fileext = ".xls")
GET(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/livebirths/datasets/babynamesinenglandandwalesfrom1996/1996tocurrent/babynames1996to2020.xls",
    write_disk(tmp))

boys <- read_xls(tmp, sheet = 4, skip = 5, na = ":", trim_ws = TRUE) %>% 
  select(seq(1, ncol(.), by = 2)) %>% 
  setNames(c("name", rev(seq(1996,2020,1)))) %>%
  mutate(name = str_to_title(name)) %>% 
  pivot_longer(-name, names_to = "year", values_to = "n") %>% 
  filter(!is.na(n)) %>% 
  mutate(year = as.integer(year),
         sex = "M",
         n = as.integer(n)) %>% 
  select(year, sex, name, n) %>% 
  arrange(year) %>% 
  group_by(year) %>% 
  mutate(rank = min_rank(desc(n)))

girls <- read_xls(tmp, sheet = 5, skip = 5, na = ":", trim_ws = TRUE) %>% 
  select(seq(1, ncol(.), by = 2)) %>% 
  setNames(c("name", rev(seq(1996,2020,1)))) %>%
  mutate(name = str_to_title(name)) %>% 
  pivot_longer(-name, names_to = "year", values_to = "n") %>% 
  filter(!is.na(n)) %>% 
  mutate(year = as.integer(year),
         sex = "F",
         n = as.integer(n)) %>% 
  select(year, sex, name, n) %>% 
  arrange(year) %>% 
  group_by(year) %>% 
  mutate(rank = min_rank(desc(n)))

bind_rows(boys, girls) %>%
  write_csv("../babynames1996to2020.csv")