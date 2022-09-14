library(tidyverse) ; library(httr) ; library(readxl)

# Child poverty after housing costs, 2020/21
# Source: End Child Poverty Coalition
# URL: http://endchildpoverty.org.uk/child-poverty

tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://endchildpoverty.org.uk/wp-content/uploads/2022/07/Child-Poverty-AHC-estimates-2015-2021-FINAL.xlsx",
    write_disk(tmp))
child_poverty <- read_xlsx(tmp, sheet = "Local Authority") %>%  
  select(area_code = `Area Code`,
         area_name = `Local authority`,
         country_region = Region,
         child_poverty = `...17`) %>% 
  slice(-1) %>% 
  mutate(area_name = str_trim(str_remove_all(area_name, pattern = "\\/.*")),
         child_poverty = round(as.numeric(child_poverty), 4)) %>% 
  filter(area_name != "City of London")

# Population-weighted annual mean PM2.5 concentration by local authority, 2020
# Source: DEFRA
# URL: https://uk-air.defra.gov.uk/data/pcm-data

air_pollution <- read_csv("https://uk-air.defra.gov.uk/datastore/pcm/popwmpm252020byUKlocalauthority.csv", skip = 2) %>% 
  select(area_name = `Local Authority`,
         air_pollution = `PM2.5 2020 (anthropogenic)`)

df <- left_join(child_poverty, air_pollution, by = "area_name") %>% 
  mutate(country_region = case_when(str_detect(area_code, "^N") ~ "Northern Ireland", 
                                    str_detect(area_code, "^S") ~ "Scotland", 
                                    str_detect(area_code, "^W") ~ "Wales",
                                    TRUE ~ country_region),
         group = case_when(country_region %in% c("South East", "East of England") ~ "South East and East of England",
                           country_region %in% c("East Midlands", "West Midlands", "North East", "North West", "Yorkshire and The Humber") ~ "Midlands and North of England",
                           country_region %in% c("Wales", "South West") ~ "Wales and South West",
                           country_region %in% c("Scotland", "Northern Ireland") ~ "Scotland and Northern Ireland",
                           TRUE ~ country_region)) %>%
  filter(!is.na(air_pollution)) %>% 
  relocate(group, .after = "country_region")

write_csv(df, "child_poverty_and_pm25.csv")
