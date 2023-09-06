#' ---
#' title: "Text analysis"
#' output: github_document
#' ---
#'
#' ## Learning objectives
#' - understand how to 'tidy' text
#' - able to run some basic analysis e.g. term frequencies
#' - familiar with basics of topic modelling
#' 

#' ## Data
#' We'll be exploring a translation of [Dante's *Divine Comedy*](https://www.gutenberg.org/cache/epub/1004/pg1004-images.html). Written in the early 1300s, the *Commedia* is broken down into three divisions: *Inferno*, *Purgatorio* and *Paradiso*).
#'
#'<img src="img/michelino.jpg" alt="Map of the Divine Comedy. Adapted from Michelangelo Caetani, c.1870" width="300"/>
#'
#' ## Setup

library(tidyverse)

#' 
#' ## Read text    
raw_text <- read_csv("data/commedia.csv")

#' 
#' ## Inspect text 
glimpse(raw_text)
raw_text %>% 
  group_by(cantica) %>% 
  summarise(n = n_distinct(canto))

#' ## Tidy text    
#' *Structure text into one word per row*     
#' 
#' ### Tokenise        
#' Convert text into tokens (e.g. characters, words, n-grams, and tweets)     
library(tidytext)
tidy_text <- raw_text %>% 
  unnest_tokens(output = word, input = text) 
tidy_text

#' ### Stop words          
#' Remove common words like 'and' and 'the'     
stop_words
other_stop_words <- tibble(word = c("ah","art","dost","doth","hast","shalt","thou","thee","thy","thine","thus"))
other_stop_words
stop_words <- bind_rows(stop_words, other_stop_words)
tidy_text <- tidy_text %>% 
  anti_join(stop_words, by = "word")
tidy_text

#' ### Word stemming and lemmatization     
#' Reduce words to simpler forms
library(SnowballC) ; library(textstem)
tidy_text %>%
  sample_n(10) %>% 
  mutate(stem = wordStem(word),
         lemm = lemmatize_words(word))

#' ## Analysing text    
#'
#' ### Term frequency     
#' **Frequency of specific term**
tidy_text %>% 
  filter(str_detect(word, "(?i)grace")) %>% 
  group_by(cantica) %>% 
  count(word, sort = TRUE)

#' **Most common terms**
tidy_text %>% 
  count(cantica, word) %>% 
  slice_max(n, n = 10) %>% 
  pivot_wider(names_from = cantica, values_from = n)

#' **Compare term frequencies between documents**
library(ggrepel)
tidy_text %>% 
  filter(cantica %in% c("Inferno", "Paradiso")) %>%
  count(cantica, word) %>%
  group_by(word) %>%
  filter(sum(n) > 50) %>%
  ungroup() %>%
  pivot_wider(names_from = "cantica", values_from = "n", values_fill = 0) %>%
  ggplot(aes(`Inferno`, `Paradiso`)) +
  geom_abline(linewidth = 1, alpha = 0.8, lty = 3) +
  geom_text_repel(aes(label = word)) +
  coord_fixed() +
  theme_classic()

#' **Term frequency - inverse document frequency**     
#' *Relative importance of a term in a document*     
tidy_text %>% 
  count(cantica, word, sort = TRUE) %>% 
  bind_tf_idf(term = word, document = cantica, n = n) %>% 
  slice_max(tf_idf, n = 10)

#' ### Sentiment analysis
get_sentiments("bing")

#' **Percentage of negative words**
tidy_text %>%
  inner_join(get_sentiments("bing"), relationship = "many-to-many") %>%
  count(cantica, sentiment) %>%
  group_by(cantica) %>%
  mutate(percent = n / sum(n) * 100) %>%
  filter(sentiment == "negative") %>%
  arrange(desc(percent))

#' **Most common negative and positive words**
tidy_text %>%
  inner_join(get_sentiments("bing"), relationship = "many-to-many") %>%
  count(word, sentiment) %>%
  group_by(sentiment) %>%
  slice_max(n, n = 10) %>%
  ungroup() %>%
  ggplot(aes(n, fct_reorder(word, n), fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ sentiment, scales = "free")

#' **Change in sentiment**
tidy_text %>% 
  inner_join(get_sentiments("bing"), by = "word", relationship = "many-to-many") %>% 
  group_by(cantica, canto) %>% 
  count(canto, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>% 
  mutate(sentiment = positive - negative) %>% 
  ggplot(aes(canto, sentiment, fill = cantica)) +
  geom_col(show.legend = FALSE) +
  geom_hline(yintercept = 0, size = 1, colour = "#212121") +
  facet_wrap(~factor(cantica, levels = c("Inferno","Purgatorio","Paradiso")), 
             scales = "free_x") +
  scale_x_continuous(expand = c(0, 0)) +
  theme_classic()

#' ### N-grams
raw_text %>% 
  unnest_tokens(bigram, text, token = "ngrams", n = 2) %>%
  separate(bigram, c("word1", "word2"), sep =" ") %>% 
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word) %>%
  unite(bigram, word1, word2, sep = " ") %>% 
  count(cantica, bigram) %>%
  bind_tf_idf(bigram, cantica, n) %>%
  arrange(desc(tf_idf))

#' ### Topic modelling
#' 
#' **Train topic model**
dtm <- tidy_text %>%
  mutate(canto = as.integer(as.roman(canto))) %>%
  unite(canto, cantica, canto, sep = "-") %>% 
  count(canto, word, sort = TRUE) %>% # each canto is a document
  cast_sparse(row = canto, column = word, value = n) # cast into a document term matrix 
dim(dtm)

#' **Create topic model**
library(stm)
topic_model <- stm(dtm, K = 5)
summary(topic_model)

#' **Topic-word probabilities**       
#' *For each topic what is the probability that we get each of these words*
word_topics <- tidy(topic_model, matrix = "beta")

word_topics %>% 
  group_by(topic) %>% 
  slice_max(beta, n = 10) %>% 
  ungroup() %>% 
  mutate(topic = paste("Topic", topic)) %>% 
  ggplot(aes(beta, reorder_within(term, beta, topic), fill = topic)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~topic, scale = "free_y") +
  scale_y_reordered() +
  labs(x = expression(beta), y = NULL)

#' **Document-topic probabilities**     
#' *For each topic and document what is the probability of that document (canto) being generated from that topic*
document_topics <- tidy(topic_model, matrix = "gamma", document_names = rownames(dtm))  

document_topics %>%
  filter(str_detect(document, "Inferno")) %>% # choose cantica
  mutate(document_name = fct_reorder(document, gamma),
         topic = factor(topic)) %>%
  ggplot(aes(gamma, topic, fill = topic)) +
  geom_col() +
  facet_wrap(vars(document_name), ncol = 4) +
  scale_x_continuous(expand = c(0, 0)) +
  labs(x = expression(gamma), y = "Topic")

#' ## Further resources
#' 
#' **Books**
#' 
#' - Silge, J., and Robinson, D. 2017. [Text Mining with R: A Tidy Approach](https://www.tidytextmining.com). Sebastopol: O’Reilly Media, Inc. 
#' - Hvitfeldt, E. and Silge, J. 2021. [Supervised Machine Learning for Text Analysis in R](https://smltar.com/). New York: Chapman and Hall/CRC.
#' - Imai, K. and Webb Williams, N., 2022. ['Textual Data' in Quantitative Social Science: An Introduction in tidyverse](https://press.princeton.edu/books/paperback/9780691222288/quantitative-social-science)
#' 
#' **Tutorials**
#' 
#' - [The game is afoot! Topic modeling of Sherlock Holmes stories](https://juliasilge.com/blog/sherlock-holmes-stm) by Julia Silge
#' - [Topic modeling for #TidyTuesday Spice Girls lyrics](https://juliasilge.com/blog/spice-girls/) by Julia Silge