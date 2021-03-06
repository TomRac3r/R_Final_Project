#Import des diff�rentes lirairies de travail
library(data.table)
library(mclust)
library(ggplot2)
library(arules)
library(rjson)
library(jsonlite)
library(dplyr)
library(recommenderlab)
library(tidytext)
library(tidyr)
library(stringr)
library(gridExtra)

set.seed(666)
#Le set.seed permet de fixer le g�n�rateur al�atoire, qui ne sera plus pris par rapport � l'heure



#Import du dataframe puis �chantillonnage � 5% du set
#Le dataframe provient d'Amazon, au format JSON et est compos� de reviews de jeu-vid�o
fichier_json = fromJSON(file = 'C:/Users/thomas/Downloads/LangageR/ScriptR/Video_Games_5.json')
fichier_json


#echantillon_donnees = sample(x = fichier_json, size = length(x*0.05), replace = FALSE)
#echantillon_donnees2 <- fichier_json[sample(nrow(fichierjson), 50), ]



#Conversion du fichier JSON en dataframe
dataframe_json <- as.data.frame(fichier_json)
dataframe_json

#On ne garde que reviewername, reviewtext et summary pour l'analyse des sentiments via les textes
dataframe_final <- dataframe_json[dataframe_json$reviewername, dataframe_json$reviewText, dataframe_json$summary]
dataframe_final


#D�but de l'analyse sentimentale
#La premi�re �tape consiste � tokeniser la partie reviewText via la fonction unnest_tokens
dataframe_final$reviewText <- as.character(dataframe_final$reviewText)
mots_revue <- dataframe_final %>%
  select(reviewerName, reviewText) %>%
  unnest_tokens(word, reviewText) %>%
  filter(!word %in% stop_words$word, str_detect(word, "^[a-z']+$"))
