# Pre-processing text #

library(tidyverse) ; library(gutenbergr) 

# Search for full texts by Dante in English
gutenberg_works(str_detect(author, "Dante"))

# Download the full text of the Divine Comedy (trans Longfellow)
# https://www.gutenberg.org/ebooks/1004
raw_text <- gutenberg_download(1004)

# without gutenbergr
# raw_text <- readLines("https://www.gutenberg.org/files/1004/1004-0.txt") %>% 
#   enframe() %>% 
#   mutate(text = iconv(value, from = "UTF-8", to = "UTF-8")) %>%
#   select(text)

# Trim text
trim_text <- raw_text %>%
  slice(126:19784)

# Annotate text
annotate_text <- trim_text %>%
  mutate(division = ifelse(str_detect(text, ": Canto"), text, NA)) %>%
  fill(division) %>% 
  mutate(cantica = word(division, 1, sep = "\\:"), # add canticle name
         canto = word(division, -1, sep = " "), # add canto number
         cantica = factor(cantica, levels = unique(cantica)))

# Clean text
clean_text <- annotate_text %>% 
  filter(nzchar(text), # remove blank lines
         !str_detect(text, ": Canto"), # remove section titles
         !str_detect(text, "PURGATORIO|PARADISO")) %>% # remove cantiche names
  mutate(text = str_trim(text)) %>% # remove white space
  group_by(cantica, canto) %>% 
  mutate(canto = as.integer(as.roman(canto)), # convert canto to Arabic numerals
         line = row_number()) %>% # add canto line number
  ungroup() %>% 
  select(text, cantica, canto, line)

# Check results
clean_text %>% 
  group_by(cantica) %>% 
  summarise(n = n_distinct(canto)) # number of canti

## Write results -----------------------------
write_csv(clean_text, "commedia.csv")
