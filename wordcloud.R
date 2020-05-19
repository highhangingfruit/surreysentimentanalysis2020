#word_cloud

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

library(wordcloud)

All_comments %>%
  anti_join(stop_words, by = 'no') %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))


