# Pre-processing text: Italian #
# Source: Project Gutenberg
# URL: https://www.gutenberg.org/ebooks/1012

raw_text <- readLines("https://www.gutenberg.org/files/1012/1012-0.txt") %>% 
  enframe() %>% 
  mutate(text = iconv(value, from = "UTF-8", to = "UTF-8")) %>%
  select(text)

trim_text <- raw_text %>%
  slice(52:19606)

annotate_text <- trim_text %>%
  mutate(division = ifelse(str_detect(text, "• Canto"), str_trim(text), NA)) %>%
  fill(division) %>% 
  mutate(cantica = word(division, 1, sep = " •"),
         canto = word(division, -1, sep = " "),
         cantica = factor(cantica, levels = unique(cantica)))

clean_text <- annotate_text %>% 
  filter(nzchar(text),
         !str_detect(text, "• Canto"),
         !str_detect(text, "PURGATORIO|PARADISO")) %>%
  mutate(text = str_trim(text)) %>%
  group_by(cantica, canto) %>% 
  mutate(canto = as.integer(as.roman(canto)),
         line = row_number()) %>%
  ungroup() %>% 
  select(text, cantica, canto, line)

write_csv(clean_text, "commedia_it.csv")
