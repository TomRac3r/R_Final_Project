## Install Package


## install.packages(c("dplyr", "jsonlite","recommenderlab","data.table","tidytext","tidyr","stringr","gridExtra","ggplot2"))

library(data.table)
library(tidyr)
library(tidytext)
library(jsonlite)
library(dplyr)
library(recommenderlab)
library(stringr)
library(gridExtra)
library(ggplot2)


## Import DataSet 


dataset_auto <- stream_in(file(fichier_dataset))
datasample <- dataset_auto[sample(nrow(dataset_auto), 250), ]

## Tokenization appliquée à reviewText
datasample$reviewText <- as.character(datasample$reviewText)
tidy_auto <- datasample %>%
  select(reviewerID,asin, reviewText, overall) %>%
  unnest_tokens(word, reviewText) %>% 
  filter(!word %in% stop_words$word, str_detect(word, "^[a-z']+$"))

## Tokenization appliquée summary
datasample$reviewText <- as.character(datasample$summary)
tidy_auto_summary <- datasample %>%
  select(reviewerID,asin, summary, overall) %>%
  unnest_tokens(word, summary) %>% 
  filter(!word %in% stop_words$word, str_detect(word, "^[a-z']+$"))


## AFINN 
afinn <- sentiments %>%
  filter(lexicon == 'AFINN') %>%
  select(word, afinn = score)

## BING
bing <- sentiments %>%
  filter(lexicon == 'bing') %>%
  mutate(bing = ifelse(sentiment == 'positive',1,-1)) %>%
  select(word, bing)

scores_revues <- tidy_auto %>%
  left_join(afinn, by = 'word') %>%
  left_join(bing, by = 'word')

sommaire_scores_revues <- scores_revues %>%
  group_by(reviewerID, overall) %>%
  summarise(afinn_score = round(mean(afinn, na.rm = T),3),
            bing_score = round(mean(bing, na.rm = T),3))

## Summary
scores_revues_summary <- tidy_auto_summary %>%
  left_join(afinn, by = 'word') %>%
  left_join(bing, by = 'word')

sommaire_scores_revues_summary <- scores_revues_summary %>%
  group_by(reviewerID, overall) %>%
  summarise(afinn_score_summary = round(mean(afinn, na.rm = T),3),
            bing_score_summary = round(mean(bing, na.rm = T),3))


## Result Display

afinn_graphique <- ggplot(sommaire_scores_revues, aes(x = as.character(overall), y = afinn_score))+
  geom_boxplot()+
  labs(x = 'Amazon Overall Score',
       y = 'AFINN text review score')

bing_graphique <- ggplot(sommaire_scores_revues, aes(x = as.character(overall), y = bing_score))+
  geom_boxplot()+
  labs(x = 'Amazon Overall Score',
       y = 'Bing text review score')

grid.arrange(afinn_graphique, bing_graphique, nrow = 2)

## Result Display Summary

afinn_graphique_summary <- ggplot(sommaire_scores_revues_summary, aes(x = as.character(overall), y = afinn_score_summary))+
  geom_boxplot()+
  labs(x = 'Amazon Overall Score',
       y = 'AFINN summary score')

bing_graphique_summary <- ggplot(sommaire_scores_revues_summary, aes(x = as.character(overall), y = bing_score_summary))+
  geom_boxplot()+
  labs(x = 'Amazon Overall Score',
       y = 'Bing summary score')

grid.arrange(afinn_graphique_summary, bing_graphique_summary, nrow = 2)


## Recommandation System

datasample_rrmatrix <- as(datasample,"realRatingMatrix")

Rec.model <- Recommender(datasample_rrmatrix[1:250], method = "UBCF")

eval <- evaluationScheme(datasample_rrmatrix[1:75], method="split", train=0.9, given=15)

rec_ubcf <- Recommender(getData(eval, "train"), "UBCF")

predict_ubcf <- predict(Rec_ubcf, getData(eval, "known"), type="ratings")

error_ubcf <- calcPredictionAccuracy(predict_ubcf, getData(eval, "unknown"))
