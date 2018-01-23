#import des diff�rentes lirairies de travail
library(data.table)
library(mclust)
library(ggplot2)
library(arules)
library(rjson)
set.seed(666)
#le set.seed permet de fixer le g�n�rateur al�atoire, qui ne sera plus pris par rapport � l'heure



#import du dataframe puis �chantillonnage � 5% du set
#le dataframe provient d'Amazon, au format JSON et est compos� de reviews de jeu-vid�o
df = fromJSON(file = 'C:/Users/thomas/Downloads/LangageR/ScriptR/Video_Games_5.json')
df
r = sample(x = dt, size = length(x*0.05), replace = FALSE)


#conversion du fichier JSON en dataframe
jsondf <- as.data.frame(r)
jsondf