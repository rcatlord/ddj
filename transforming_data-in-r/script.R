# Transforming data in R # 

# packages ----------------------------
install.packages(c("dplyr", "palmerpenguins"), dependencies = TRUE, type = "win.binary")
library(dplyr) ; library(palmerpenguins)

# inspect ----------------------------
penguins
glimpse(penguins)

# the pipe ----------------------------
penguins %>%
  count(species) %>%
  mutate(prop = n / sum(n)) 

# select() ----------------------------

# by name
penguins %>% 
  select(species, island, sex, body_mass_g)

# by exclusion
penguins %>% 
  select(!species)

# a consecutive range
penguins %>% 
  select(1:3)

# begins with
penguins %>% 
  select(starts_with("bill"))

# by numeric
penguins %>% 
  select(where(is.numeric))

# reorder
penguins %>% 
  select(year, island, species, sex, everything())

# rename() ----------------------------
penguins %>% 
  rename(culmen_length_mm = bill_length_mm, 
         culmen_depth_mm = bill_depth_mm)

# mutate() ----------------------------

# calculate
penguins %>% 
  mutate(bill_ratio = bill_length_mm / bill_depth_mm)

# recode
penguins %>% 
  mutate(category = case_when(
    body_mass_g <= 3000 ~ "small",
    body_mass_g > 3000 & body_mass_g <= 4500 ~ "medium",
    body_mass_g > 4500 ~ "large")
  )

# relevel
penguins %>% 
  mutate(island = forcats::fct_relevel(island, "Torgersen", "Biscoe", "Dream"))

# relocate() ----------------------------

# to beginning
penguins %>%
  relocate(year)

# after specific variable
penguins %>% 
  relocate(contains("_"), .after = year)

# after type
penguins %>%
  relocate(where(is.numeric), .after = where(is.factor))

# filter() ----------------------------

# greater to
penguins %>% 
  filter(bill_length_mm >= 50)

# equal to
penguins %>% 
  filter(island == "Biscoe")

# not equal to
penguins %>% 
  filter(!is.na(sex))

# with regex
penguins %>% 
  filter(stringr::str_detect(island, "^T"))

# by multiple conditions
penguins %>% 
  filter(island == "Torgersen" & year == 2009)

# by a vector
penguins %>% 
  filter(species %in% c("Chinstrap", "Gentoo"))

# slice() ----------------------------
penguins %>% 
  slice(1:5)

# arrange() ----------------------------

# ascending order
penguins %>% 
  arrange(bill_length_mm)

# descending order
penguins %>% 
  arrange(desc(bill_length_mm))

# count() ----------------------------

# by one variable
penguins %>% 
  count(island)

# by two variables and sort
penguins %>% 
  count(island, sex, sort = TRUE)

# group_by() and summarise() ----------------------------
penguins %>% 
  group_by(island) %>% 
  summarise(mean_body_mass_g = mean(body_mass_g, na.rm = TRUE))

# across() ----------------------------
penguins %>%
  group_by(species) %>%
  summarize(across(c(bill_length_mm, body_mass_g), mean, na.rm = TRUE))
