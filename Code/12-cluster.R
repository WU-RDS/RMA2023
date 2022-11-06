
options(scipen = 999)
set.seed(1)


load(url("https://github.com/WU-RDS/MRDA2021/raw/main/trackfeatures.RData"))
# remove duplicates
tracks <- na.omit(tracks[!duplicated(tracks$isrc), ])



library(ggplot2)
library(stringr)
robin_schulz <- tracks[str_detect(tracks$artistName, "Robin Schulz"), ]
robin_schulz$artist <- "Robin Schulz"
adele <- tracks[str_detect(tracks$artistName, "Adele"), ]
adele$artist <- "Adele"

example_tracks <- rbind(robin_schulz, adele)
ggplot(example_tracks, aes(x = energy, y = acousticness, color = artist)) +
  geom_point() +
  theme_bw()



tracks_scale <- data.frame(artist = example_tracks$artist, energy = scale(example_tracks$energy), acousticness = scale(example_tracks$acousticness))
tracks_scale <- na.omit(tracks_scale)
kmeans_clusters <- kmeans(tracks_scale[-1], 2)
kmeans_clusters$centers



tracks_scale$cluster <- as.factor(kmeans_clusters$cluster)
ggplot(tracks_scale, aes(x = energy, y = acousticness, color = cluster, shape = artist)) +
  geom_point(size = 3) +
  theme_bw()
table(tracks_scale$artist, tracks_scale$cluster)



library(NbClust)
famous_artists <- c(
	'Ed Sheeran',
	'Eminem',
	'Rihanna',	
	'Taylor Swift',
	'Queen'
	)
famous_tracks <- tracks[tracks$artistName %in% famous_artists, ]
famous_tracks_scale <- scale(famous_tracks[4:ncol(famous_tracks)])
set.seed(123)
opt_K <- NbClust(famous_tracks_scale, method = "kmeans", max.nc = 10)



table(opt_K$Best.nc["Number_clusters",])



kmeans_tracks <- kmeans(famous_tracks_scale, 3)
kmeans_tracks$centers



library(ggiraph)
library(ggiraphExtra)

centers <- data.frame(kmeans_tracks$centers)
centers$cluster <- 1:3
ggRadar(centers, aes(color = cluster), rescale = FALSE) + 
  ggtitle("Centers") +
  theme_bw()



famous_tracks$cluster <- as.factor(kmeans_tracks$cluster)
ggplot(famous_tracks, aes(y = cluster, fill = artistName)) +
  geom_bar() +
  theme_bw()
table(famous_tracks$artistName, famous_tracks$cluster)



recommendation <- famous_tracks[str_detect(famous_tracks$trackName, "Lose Yourself|I Forgot That You Existed|The Archer"),]
recommendation[c("trackName", "artistName", "cluster")]
ggplot(recommendation, aes(instrumentalness, speechiness, color = cluster)) +
  geom_point() +
  geom_label(aes(label=trackName), hjust = "inward") +
  theme_bw()


library(factoextra)
fviz_cluster(kmeans_tracks, data = famous_tracks_scale,
             palette = hcl.colors(3, palette = "Dynamic"), 
             geom = "point",
             ellipse.type = "convex", 
             ggtheme = theme_bw()
             )


pf_ri <- tracks[tracks$artistName %in% c("Pink Floyd", "Rihanna"),]
pf_ri_scale <- scale(pf_ri[,4:ncol(pf_ri)])
rownames(pf_ri_scale) <- pf_ri$trackName
hclust_tracks <- hclust(dist(pf_ri_scale))
plot(hclust_tracks)



hclusters <- cutree(hclust_tracks,4)
pf_ri_hier <- data.frame(pf_ri_scale)
pf_ri_hier$cluster <- as.factor(hclusters)
hier_centers <- aggregate(. ~ cluster, pf_ri_hier, mean)
ggRadar(hier_centers, aes(color = cluster), rescale = T) + 
  ggtitle("Centers") +
  theme_bw()

