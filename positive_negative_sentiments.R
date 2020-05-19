#sentiment_analysis

# for data wrangling
library(tidyr)
library(stringr)
library(magrittr)
library(dplyr)
library(lubridate)

# for sentiment analysis
library(tidytext)
library(textdata)

# for visualization
library(ggplot2)
library(ggridges)

All_comments <- read.csv("C:/Users/melxt/Documents/sentimentanalysis/sentiment_anal.csv",
                         header=TRUE, stringsAsFactors=FALSE)
#All_comments %>% glimpse()

# Get covid comments
#All_covid_comments <- All_comments %>%
#filter(str_detect(body, "covid")) %>% glimpse()
#write.csv((All_covid_comments), "all_covid_mentions.csv")


new_sentiments_nrc <- get_sentiments("nrc")
names(new_sentiments)[names(new_sentiments) == 'value'] <- 'score'
new_sentiments_nrc <- new_sentiments %>% mutate(lexicon = "nrc", sentiment = ifelse(score >= 0, "positive", "negative"),
                                            words_in_lexicon = n_distinct((word)))

print(new_sentiments_nrc)

all_sentiment_nrc <- All_comments %>%
  select(body, title, comms_num, timestamp) %>%
  unnest_tokens(word, body) %>%
  anti_join(stop_words) %>%
  inner_join(new_sentiments_nrc, by = "word") %>%
  group_by(sentiment) %>%
  summarize(comms_num = n()) %>%
  ungroup() %>%
  mutate(sentiment = reorder(sentiment, comms_num)) %>%
  ggplot(aes(sentiment, comms_num, fill = -comms_num)) +
  geom_col() +
  guides(fill=FALSE)+
  ggtitle("Positive vs Negative Comment Counts")

all_sentiment_graph

write.csv(all_sentiment_graph, "reddit_all_sentiment_graph.csv")

