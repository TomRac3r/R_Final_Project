# R_Final_Project
Final project for R-lectures, objectiv is to create a recommander system


Le projet consiste à construire un mini système de recommendation avec le logiciel R. Le développement sera réalisé en binôme en utilisant
un dépôt Git permettant d'identifier clairement les contributions de chaque membre du binôme.

Vous êtes libres de choisir le jeu de données sur lequel vous souhaitez travailler. Un exemple de données classiques est le jeu de données 
Yelp. Vous pouvez ramener le jeu de données original à des dimensions qui tiennent facilement en mémoire (min. 5000-10000 évaluations,
250-500 utilisateurs), en détaillant la technique utilisée pour le sous-échantillonnage aléatoire de la base initiale. Le format de la base
de données (SQL, JSON, CSV) n'a pas d'importance.

Voici deux exemples de méta-dépôts de sources de données disponibles sur internet, mais il doit en exister d'autres :

http://shuaizhang.tech/2017/03/15/Datasets-For-Recommender-System/
https://gist.github.com/entaroadun/1653794
Le jeu de données final doit ressembler aux matrices utilisateur/item classiques mais au lieu de travailler sur la fréquence d'occurence 
des items, on utilisera un système de "rating" numérique comme pour les données beers.csv traitées en TP et en cours. Il faudra donc choisir
un jeu de données incluant des évaluations sous forme de commentaires textuels par les utilisateurs pour chacun des items.

Par exemple, le jeu de données Amazon product data est un jeu de données répondant à ces caractéristiques puisque les champs stockés
contiennent un ID utilisateur (reviewerID), un ID item (asin) et un champ textuel (reviewText) qui peut être analysé par text mining 
classique (texte anglais)



{
  "reviewerID": "A2SUAM1J3GNN3B",
  
  "asin": "0000013714",
  
  "reviewerName": "J. McDonald",
  
  "helpful": [2, 3],
  
  "reviewText": "I bought this for my husband who plays the piano.  He is having a wonderful time playing these old hymns. 
  The music  is at times hard to read because we think the book was published for singing from more than playing from.  
  Great purchase though!",
  
  "overall": 5.0,
  
  "summary": "Heavenly Highway Hymns",
  
  "unixReviewTime": 1252800000,
  
  "reviewTime": "09 13, 2009"
}



L'idée est de dériver un système de poids numérique pour la matrice utilisateur/item, comme discuté dans le cours ou le 2e TP, mais à partir 
des évaluations textuelles fournies par les utilisateurs. Pour cela, vous appliquerez une technique d'analyse de sentiment afin de calculer
un score continu reflétant la polarité des revues (positive, neutre, négative) basé sur une revue par l'utilisateur de l'item acheté ou évalué.

Le choix du lexique de codage des sentiments est libre mais vous pouvez vous aider de cette revue technique : A Pair of Text Analysis 
Explorations. Pour le projet, vous utiliserez obligatoirement deux types de scoring (p.ex. AFFIN et Bing, ou Bing et Sentiword). Quelle que 
soit la technique retenue pour le scoring des évaluations textuelles, il faudra fournir un petit justificatif (2-3 paragraphes) pour le choix 
du lexique et/ou de l'algorithme de scoring.
Les packages listés dans le diaporama #6 sur le "data mining" pourront être utiles, en particulier {tidytext}, {syuzhet} ou {sentimentr}.

Le schéma de construction pour le système de recommendation sera de type UCBF (filtrage collaboratif explicite basé sur les utilisateurs). 
Pour évaluer la qualité prédictive du modèle, on utilisera la technique de masquage décrire dans l'article "A Gentle Introduction to 
Recommender Systems with Implicit Feedback" (§ Creating a Training and Validation Set) et on vérifiera que le modèle prédit "correctement" 
les items masqués pour certains utilisateurs. Les valeurs de Precision/Recall (ou F-score, ou n'importe quelle autre mesure utile pour 
quantifier la qualité de prédiction d'un modèle statistique) seront calculées sur l'échantillon de validation pour chacune des techniques de 
scoring de sentiment retenues (cf. paragraphe précédent).

En d'autres termes, l'analyse consistera à résumer l'évaluation textuelle d'un item à l'aide d'un score numérique calculé de deux manières
différentes et à évaluer les performances prédictives du modèle de recommendation sur un échantillon de validation (dérivé via technique de
masking) dans les deux cas de figure. Une discussion critique des résultats est attendue (max. 1 page).

Le rendu de projet inclura : (1) un mini rapport (3-4 pages) décrivant les principales étapes de pré-traitement des données, de construction
et de validation du modèle ; (2) le code source R utilisé ; (3) le fichier log de votre dépôt Git.

____________________________________________________________________________________________________________________________________________
(PROJET EN COURS!!!)
Projet final R
« Mini-système de recommandation »


I/ Rapport 
Construction du projet :
Import des data en JSON, puis réduction aux champs voulus et échantillonnage.
Ensuite, on applique le format « tidytext » aux champs reviewText et summary pour obtenir un tableau ne contenant que les mots qui sont importants pour l’analyse.
L’analyse sentimentale vient ensuite, on fera cette analyse via deux lexicons (Bing et NRC) en vue d’obtenir un scoring.
Une fois le scoring obtenu, on construira le système de recommandation en UCBF.

1/ Choix des données 
Le choix du jeu de données de base provient du site http://jmcauley.ucsd.edu/data/amazon/links.html. 
Les datasets contiennent des avis (reviews) de produits provenant du site Amazon. Nous utiliserons un dataset réduit fait pour les expérimentations, ici le choix se portera sur le fichier contenant 231.780 reviews de jeux-vidéo.
Le dataset importer est au format JSON et se présente de la forme :
    reviewerID       asin reviewerName helpful
134037 AXM4SLU87FCT7 B002GPPPS4  Vicki Cantu    0, 0
                                                                                                                              reviewText
134037 This was a cool gMe very different then the ones I used to play but still very enjoyable for the price I'll give it two thumbs up
       overall   summary unixReviewTime reviewTime
134037       4 Cool game     1386460800 12 8, 2013
Ce dataset brut contient plusieurs champs, reviewerID, asin, reviewerName, helpful, reviewText, overall, summary, unixReviewTime et reviewTime.
La seconde étape consistera à échantillonner le dataset, pour ne garder qu’un certain nombre de reviews et ainsi éviter le traitement des 231.780 reviews.

2/ Echantillonnage 
Comme vu précédemment, le dataset importer contient 231.780 reviews. Pour limiter le temps de travail des machines et permettre de refaire l’expérimentation rapidement, nous allons échantillonner ce set avec une valeur arbitraire de 50 reviews.

3/ Mise en forme + « tidytext »
La troisième tape de notre travail consistera à mettre en forme le dataset pour qu’il soit plus exploitable et ne garde que les champs utiles à l’analyse sentimentale. Ici, nous avons décidé de garder les champs « reviewerName », « reviewText » et « summary ». Nous choisissons de garder le champ « summary » pour essayer de faire une analyse sentimentale dessus et ensuite la comparer avec l’analyse sentimentale faite sur le champ « reviewText » (la comparaison de ces deux champs est questionnable, en effet, plus un texte est long, plus l’analyse sentimentale sera performante. Toutefois, pour notre projet, nous voulons expérimenter cette option).
La dernière étape de pré-traitement des données sera la mise en forme finale faite via le package « tidytext ». 

4/ Analyse de sentiment + score 
5/ Système de recommandation


