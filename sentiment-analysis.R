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


new_sentiments <- get_sentiments("afinn")
names(new_sentiments)[names(new_sentiments) == 'value'] <- 'score'
new_sentiments <- new_sentiments %>% mutate(lexicon = "afinn", sentiment = ifelse(score >= 0, "positive", "negative"),
                                            words_in_lexicon = n_distinct((word)))


all_sentiment <- All_comments %>%
  select(body, title, comms_num, timestamp) %>%
  unnest_tokens(word, body) %>%
  anti_join(stop_words) %>%
  inner_join(new_sentiments, by = "word") %>%
  group_by(comms_num, word) %>%
  summarize(sentiment = mean(score))

all_sentiment


write.csv(all_sentiment, "reddit_all_sentiment.csv")


all_sentiment_wordcount <- all_sentiment %>%
  select(comms_num, word, sentiment) %>%
  group_by(word) %>%
  tally()

Bind_sent_and_word <- all_sentiment %>%
  full_join(all_sentiment_wordcount, by="word")

#print(Bind_sent_and_word)

ggplot(Bind_sent_and_word, aes(y=comms_num, x=sentiment, color=word)) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1, hjust = 1) +
  geom_hline(yintercept = mean(Bind_sent_and_word$sentiment), color = "red", lty = 2)
