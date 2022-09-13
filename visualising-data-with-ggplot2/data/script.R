# UK emissions by sector 
# Source: Department for Business, Energy & Industrial Strategy
# URL: https://www.gov.uk/government/statistics/provisional-uk-greenhouse-gas-emissions-national-statistics-2021

library(tidyverse) ; library(httr) ; library(readxl)

tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1064926/2021-provisional-emissions-data-tables.xlsx",
    write_disk(tmp))

df <- read_xlsx(tmp, sheet = "Table1", skip = 4) %>% 
  pivot_longer(-`NC Sector`, names_to = "year", values_to = "value") %>% 
  rename(sector = `NC Sector`) %>% 
  mutate(sector = str_replace_all(sector, " \\[[^\\]]*\\]", "")) %>% 
  filter(!sector %in% c("from power stations", "other Energy supply", "Total greenhouse gases", "Other greenhouse gases", "Total CO2")) %>% 
  mutate(sector = case_when(
    sector %in% c("Agriculture", "Industrial processes", "LULUCF", "Public", "Waste management") ~ "Other",
    TRUE ~ sector)) %>% 
  group_by(year, sector) %>% 
  summarise(value = sum(value))

write_csv(df, "2021-provisional-emissions-data-tables.csv")
