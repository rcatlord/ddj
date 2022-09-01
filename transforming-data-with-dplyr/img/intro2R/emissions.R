# https://www.gov.uk/government/statistics/final-uk-greenhouse-gas-emissions-national-statistics-1990-to-2020#full-publication-update-history

library(tidyverse) ; library(httr) ; library(readxl)

tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1064949/final-greenhouse-gas-emissions-tables-2020.xlsx",
    write_disk(tmp))
raw <- read_xlsx(tmp, sheet = "1.2", skip = 5) %>% 
  select(-`NC Category`)

df <- raw %>% 
  rename(sector = `NC Sector`) %>% 
  filter(sector %in% c("Energy supply", "Business", "Transport", "Public", "Residential",
                            "Agriculture", "Industrial processes", "Land use, land use change and forestry",
                            "Waste management")) %>% 
  mutate(sector = case_when(sector %in% c("Public", "Industrial processes", "Land use, land use change and forestry") ~ "Other",
                            TRUE ~ sector)) %>% 
  pivot_longer(-sector, names_to = "year", values_to = "value") %>% 
  group_by(sector, year) %>% 
  summarise(value = sum(value)) 

glimpse(df)

ggplot(df, aes(x = year, y = value, group = sector, color = sector)) +
  geom_line() + 
  theme_minimal()
