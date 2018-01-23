#import des différentes lirairies de travail
library(data.table)
library(mclust)
library(ggplot2)
library(arules)
library(rjson)
set.seed(666)
#le set.seed permet de fixer le générateur aléatoire, qui ne sera plus pris par rapport à l'heure



#import du dataframe puis échantillonnage à 5% du set
#le dataframe provient d'Amazon, au format JSON et est composé de reviews de jeu-vidéo
df = fromJSON(file = 'C:/Users/thomas/Downloads/LangageR/ScriptR/Video_Games_5.json')
df
r = sample(x = dt, size = length(x*0.05), replace = FALSE)


#conversion du fichier JSON en dataframe
jsondf <- as.data.frame(r)
jsondf