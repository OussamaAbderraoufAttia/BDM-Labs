##############################################################################
# TP3 Bis : Familiarisation avec les donnees
# Transformation de donnees - ACP, Clustering, Selection d'attributs
##############################################################################

# --- Dossier de travail ---
# On s'assure d'etre au bon endroit
try({
  setwd("c:/Users/s/BDM/TP4/TP3_Bis")
}, silent = TRUE)

# --- Creation du dossier de resultats ---
if (!dir.exists("results")) dir.create("results", recursive = TRUE)

# --- Activation du Logging ---
# Redirige toute la sortie console vers un fichier ET la console (split=TRUE)
log_file <- "results/log_results.txt"
sink(log_file, append = FALSE, split = TRUE)

cat("\n[LOG] Analyse lancee le :", as.character(Sys.time()), "\n")
cat("[LOG] Dossier de travail :", getwd(), "\n")
cat("[LOG] Fichiers sauvegardes dans :", file.path(getwd(), "results"), "\n")

# --- Installation et chargement des packages ---
cat("\n[LOG] Chargement des packages...\n")
packages <- c("FactoMineR", "factoextra", "cluster", "FSelector", "mlbench", "ggplot2")
for (pkg in packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat("[LOG] Installation de", pkg, "...\n")
    install.packages(pkg, repos = "https://cran.rstudio.com/")
  }
}

library(FactoMineR)
library(factoextra)
library(cluster)
library(FSelector)
library(mlbench)
library(ggplot2)

##############################################################################
# ===== PARTIE 1 : DATASET IRIS =====
##############################################################################

cat("\n" , paste(rep("=", 50), collapse = ""), "\n")
cat("========== DATASET IRIS ==========\n")
cat(paste(rep("=", 50), collapse = ""), "\n")

# --- 1.1 Chargement et caracteristiques ---
data(iris)
cat("\nDimensions du dataset Iris:\n")
print(dim(iris))
cat("\nResume statistique:\n")
print(summary(iris))

# Sauvegarder le CSV
write.csv(iris, "results/iris_data.csv", row.names = FALSE)
cat("[SAVE] iris_data.csv\n")

# Donnees numeriques uniquement (sans Species)
iris_num <- iris[, 1:4]
iris_scaled <- scale(iris_num)

# --- 1.2 ACP sur Iris ---
cat("\n--- ACP sur Iris ---\n")
T1 <- Sys.time()
acp_iris <- PCA(iris_num, ncp = ncol(iris_num), graph = FALSE)
T2 <- Sys.time()
cat("Temps d'execution ACP Iris:", format(T2 - T1), "\n")

# Resume ACP
cat("\nValeurs propres (eigenvalues):\n")
print(acp_iris$eig)

# Graphique des valeurs propres
png("results/iris_acp_screeplot.png", width = 800, height = 600)
p <- fviz_eig(acp_iris, addlabels = TRUE) + labs(title = "Iris - Eboulis des valeurs propres (ACP)")
print(p)
dev.off()
cat("[SAVE] iris_acp_screeplot.png\n")

# Graphique des individus
png("results/iris_acp_individus.png", width = 800, height = 600)
p <- fviz_pca_ind(acp_iris, geom.ind = "point",
             col.ind = iris$Species,
             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
             addEllipses = TRUE, legend.title = "Espece",
             title = "Iris - ACP : Plan des individus")
print(p)
dev.off()
cat("[SAVE] iris_acp_individus.png\n")

# Graphique des variables
png("results/iris_acp_variables.png", width = 800, height = 600)
p <- fviz_pca_var(acp_iris, col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             title = "Iris - ACP : Cercle des correlations")
print(p)
dev.off()
cat("[SAVE] iris_acp_variables.png\n")

# Biplot
png("results/iris_acp_biplot.png", width = 800, height = 600)
p <- fviz_pca_biplot(acp_iris, col.ind = iris$Species,
                palette = c("#00AFBB", "#E7B800", "#FC4E07"),
                addEllipses = TRUE, legend.title = "Espece",
                title = "Iris - ACP : Biplot")
print(p)
dev.off()
cat("[SAVE] iris_acp_biplot.png\n")

# Extraction des composantes > 80% de qualite
cumvar <- cumsum(acp_iris$eig[, 2])
nb_comp_80 <- which(cumvar >= 80)[1]
cat("\nNombre de composantes pour >= 80% de variance:", nb_comp_80, "\n")
cat("Variance cumulee:\n")
print(cumvar)

# Donnees projetees sur les composantes retenues
iris_pca_data <- acp_iris$ind$coord[, 1:nb_comp_80]

# --- 1.3 Clustering K-means sur donnees originales ---
cat("\n--- Clustering K-means sur Iris (donnees originales) ---\n")

# Methode Elbow avec fviz_nbclust
png("results/iris_elbow_original.png", width = 800, height = 600)
p <- fviz_nbclust(iris_scaled, kmeans, method = "wss") +
  labs(title = "Iris - Methode Elbow (donnees originales)")
print(p)
dev.off()
cat("[SAVE] iris_elbow_original.png\n")

# Methode Elbow manuelle
k.max <- 10
wss_iris <- sapply(1:k.max, function(k) {
  kmeans(iris_scaled, k, nstart = 50, iter.max = 15)$tot.withinss
})
cat("\nWSS pour k=1 a", k.max, ":\n")
print(wss_iris)

png("results/iris_elbow_manual.png", width = 800, height = 600)
plot(1:k.max, wss_iris, type = "b", pch = 19, frame = FALSE,
     xlab = "Nombre de clusters K",
     ylab = "Somme des carres intra-cluster (WSS)",
     main = "Iris - Methode Elbow (manuelle)")
dev.off()
cat("[SAVE] iris_elbow_manual.png\n")

# Methode Silhouette
png("results/iris_silhouette_optimal.png", width = 800, height = 600)
p <- fviz_nbclust(iris_scaled, kmeans, method = "silhouette") +
  labs(title = "Iris - Methode Silhouette (donnees originales)")
print(p)
dev.off()
cat("[SAVE] iris_silhouette_optimal.png\n")

# K-means avec k optimal (k=3 pour iris)
k_iris <- 3
T1 <- Sys.time()
km_iris_original <- kmeans(iris_scaled, centers = k_iris, nstart = 50)
T2 <- Sys.time()
cat("\nTemps d'execution K-means Iris (original):", format(T2 - T1), "\n")
cat("Taille des clusters:\n")
print(km_iris_original$size)
cat("Centres des clusters:\n")
print(km_iris_original$centers)
cat("WSS total:", km_iris_original$tot.withinss, "\n")
cat("BSS/TSS ratio:", km_iris_original$betweenss / km_iris_original$totss, "\n")

# Visualisation clusplot
png("results/iris_clusplot_original.png", width = 800, height = 600)
clusplot(iris_scaled, km_iris_original$cluster,
         color = TRUE, shade = TRUE, labels = 2, lines = 0,
         main = "Iris - Clusplot (donnees originales)")
dev.off()
cat("[SAVE] iris_clusplot_original.png\n")

# Silhouette du clustering
sil_iris_original <- silhouette(km_iris_original$cluster, dist(iris_scaled))
cat("Silhouette moyenne (original):", mean(sil_iris_original[, 3]), "\n")

png("results/iris_silhouette_plot_original.png", width = 800, height = 600)
p <- fviz_silhouette(sil_iris_original) + labs(title = "Iris - Silhouette (donnees originales)")
print(p)
dev.off()
cat("[SAVE] iris_silhouette_plot_original.png\n")

# --- 1.4 Clustering K-means sur composantes principales ---
cat("\n--- Clustering K-means sur Iris (composantes principales) ---\n")

T1 <- Sys.time()
km_iris_pca <- kmeans(iris_pca_data, centers = k_iris, nstart = 50)
T2 <- Sys.time()
cat("Temps d'execution K-means Iris (PCA):", format(T2 - T1), "\n")
cat("Taille des clusters:\n")
print(km_iris_pca$size)
cat("WSS total:", km_iris_pca$tot.withinss, "\n")
cat("BSS/TSS ratio:", km_iris_pca$betweenss / km_iris_pca$totss, "\n")

png("results/iris_clusplot_pca.png", width = 800, height = 600)
clusplot(iris_pca_data, km_iris_pca$cluster,
         color = TRUE, shade = TRUE, labels = 2, lines = 0,
         main = "Iris - Clusplot (composantes principales)")
dev.off()
cat("[SAVE] iris_clusplot_pca.png\n")

sil_iris_pca <- silhouette(km_iris_pca$cluster, dist(iris_pca_data))
cat("Silhouette moyenne (PCA):", mean(sil_iris_pca[, 3]), "\n")

png("results/iris_silhouette_plot_pca.png", width = 800, height = 600)
p <- fviz_silhouette(sil_iris_pca) + labs(title = "Iris - Silhouette (composantes principales)")
print(p)
dev.off()
cat("[SAVE] iris_silhouette_plot_pca.png\n")

# --- 1.5 Selection d'attributs ---
cat("\n--- Selection d'attributs sur Iris ---\n")

T1 <- Sys.time()
result_iris <- cfs(Species ~ ., iris)
T2 <- Sys.time()
cat("Temps d'execution selection CFS:", format(T2 - T1), "\n")
cat("Attributs selectionnes:\n")
print(result_iris)

f_iris <- as.simple.formula(result_iris, "Species")
cat("Formule:\n")
print(f_iris)

# Donnees avec attributs selectionnes
iris_selected <- iris[, result_iris]
iris_selected_scaled <- scale(iris_selected)

# --- 1.6 Clustering sur donnees selectionnees ---
cat("\n--- Clustering K-means sur Iris (attributs selectionnes) ---\n")

png("results/iris_elbow_selected.png", width = 800, height = 600)
p <- fviz_nbclust(iris_selected_scaled, kmeans, method = "wss") +
  labs(title = "Iris - Methode Elbow (attributs selectionnes)")
print(p)
dev.off()
cat("[SAVE] iris_elbow_selected.png\n")

T1 <- Sys.time()
km_iris_selected <- kmeans(iris_selected_scaled, centers = k_iris, nstart = 50)
T2 <- Sys.time()
cat("Temps d'execution K-means Iris (selected):", format(T2 - T1), "\n")
cat("Taille des clusters:\n")
print(km_iris_selected$size)
cat("WSS total:", km_iris_selected$tot.withinss, "\n")
cat("BSS/TSS ratio:", km_iris_selected$betweenss / km_iris_selected$totss, "\n")

png("results/iris_clusplot_selected.png", width = 800, height = 600)
clusplot(iris_selected_scaled, km_iris_selected$cluster,
         color = TRUE, shade = TRUE, labels = 2, lines = 0,
         main = "Iris - Clusplot (attributs selectionnes)")
dev.off()
cat("[SAVE] iris_clusplot_selected.png\n")

sil_iris_selected <- silhouette(km_iris_selected$cluster, dist(iris_selected_scaled))
cat("Silhouette moyenne (selected):", mean(sil_iris_selected[, 3]), "\n")

png("results/iris_silhouette_plot_selected.png", width = 800, height = 600)
p <- fviz_silhouette(sil_iris_selected) + labs(title = "Iris - Silhouette (attributs selectionnes)")
print(p)
dev.off()
cat("[SAVE] iris_silhouette_plot_selected.png\n")

# --- 1.7 Comparaison des resultats Iris ---
cat("\n\n========== COMPARAISON DES RESULTATS IRIS ==========\n")
cat(sprintf("%-25s | %-10s | %-10s | %-10s\n", "Methode", "WSS", "BSS/TSS", "Silhouette"))
cat(paste(rep("-", 65), collapse = ""), "\n")
cat(sprintf("%-25s | %-10.2f | %-10.4f | %-10.4f\n",
            "Donnees originales",
            km_iris_original$tot.withinss,
            km_iris_original$betweenss / km_iris_original$totss,
            mean(sil_iris_original[, 3])))
cat(sprintf("%-25s | %-10.2f | %-10.4f | %-10.4f\n",
            "Composantes principales",
            km_iris_pca$tot.withinss,
            km_iris_pca$betweenss / km_iris_pca$totss,
            mean(sil_iris_pca[, 3])))
cat(sprintf("%-25s | %-10.2f | %-10.4f | %-10.4f\n",
            "Attributs selectionnes",
            km_iris_selected$tot.withinss,
            km_iris_selected$betweenss / km_iris_selected$totss,
            mean(sil_iris_selected[, 3])))

##############################################################################
# ===== PARTIE 2 : DATASET GLASS =====
##############################################################################

cat("\n" , paste(rep("=", 50), collapse = ""), "\n")
cat("========== DATASET GLASS ==========\n")
cat(paste(rep("=", 50), collapse = ""), "\n")

# --- 2.1 Chargement et caracteristiques ---
data(Glass)
cat("\nDimensions du dataset Glass:\n")
print(dim(Glass))
cat("\nResume statistique:\n")
print(summary(Glass))

write.csv(Glass, "results/glass_data.csv", row.names = FALSE)
cat("[SAVE] glass_data.csv\n")

glass_num <- Glass[, 1:9]
glass_scaled <- scale(glass_num)

# --- 2.2 ACP sur Glass ---
cat("\n--- ACP sur Glass ---\n")
T1 <- Sys.time()
acp_glass <- PCA(glass_num, ncp = ncol(glass_num), graph = FALSE)
T2 <- Sys.time()
cat("Temps d'execution ACP Glass:", format(T2 - T1), "\n")

cat("\nValeurs propres (eigenvalues):\n")
print(acp_glass$eig)

png("results/glass_acp_screeplot.png", width = 800, height = 600)
p <- fviz_eig(acp_glass, addlabels = TRUE) + labs(title = "Glass - Eboulis des valeurs propres (ACP)")
print(p)
dev.off()
cat("[SAVE] glass_acp_screeplot.png\n")

png("results/glass_acp_individus.png", width = 800, height = 600)
p <- fviz_pca_ind(acp_glass, geom.ind = "point",
             col.ind = Glass$Type,
             addEllipses = TRUE, legend.title = "Type",
             title = "Glass - ACP : Plan des individus")
print(p)
dev.off()
cat("[SAVE] glass_acp_individus.png\n")

png("results/glass_acp_variables.png", width = 800, height = 600)
p <- fviz_pca_var(acp_glass, col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             title = "Glass - ACP : Cercle des correlations")
print(p)
dev.off()
cat("[SAVE] glass_acp_variables.png\n")

cumvar_glass <- cumsum(acp_glass$eig[, 2])
nb_comp_80_glass <- which(cumvar_glass >= 80)[1]
cat("\nNombre de composantes pour >= 80% de variance:", nb_comp_80_glass, "\n")
cat("Variance cumulee:\n")
print(cumvar_glass)

glass_pca_data <- acp_glass$ind$coord[, 1:nb_comp_80_glass]

# --- 2.3 Clustering K-means sur donnees originales ---
cat("\n--- Clustering K-means sur Glass (donnees originales) ---\n")

png("results/glass_elbow_original.png", width = 800, height = 600)
p <- fviz_nbclust(glass_scaled, kmeans, method = "wss") +
  labs(title = "Glass - Methode Elbow (donnees originales)")
print(p)
dev.off()
cat("[SAVE] glass_elbow_original.png\n")

png("results/glass_silhouette_optimal.png", width = 800, height = 600)
p <- fviz_nbclust(glass_scaled, kmeans, method = "silhouette") +
  labs(title = "Glass - Methode Silhouette (donnees originales)")
print(p)
dev.off()
cat("[SAVE] glass_silhouette_optimal.png\n")

# K-means avec k=6 (6 types de verre)
k_glass <- 6
T1 <- Sys.time()
km_glass_original <- kmeans(glass_scaled, centers = k_glass, nstart = 50)
T2 <- Sys.time()
cat("Temps d'execution K-means Glass (original):", format(T2 - T1), "\n")
cat("Taille des clusters:\n")
print(km_glass_original$size)
cat("WSS total:", km_glass_original$tot.withinss, "\n")
cat("BSS/TSS ratio:", km_glass_original$betweenss / km_glass_original$totss, "\n")

png("results/glass_clusplot_original.png", width = 800, height = 600)
clusplot(glass_scaled, km_glass_original$cluster,
         color = TRUE, shade = TRUE, labels = 2, lines = 0,
         main = "Glass - Clusplot (donnees originales)")
dev.off()
cat("[SAVE] glass_clusplot_original.png\n")

sil_glass_original <- silhouette(km_glass_original$cluster, dist(glass_scaled))
cat("Silhouette moyenne (original):", mean(sil_glass_original[, 3]), "\n")

png("results/glass_silhouette_plot_original.png", width = 800, height = 600)
p <- fviz_silhouette(sil_glass_original) + labs(title = "Glass - Silhouette (donnees originales)")
print(p)
dev.off()
cat("[SAVE] glass_silhouette_plot_original.png\n")

# --- 2.4 Clustering sur composantes principales ---
cat("\n--- Clustering K-means sur Glass (composantes principales) ---\n")

T1 <- Sys.time()
km_glass_pca <- kmeans(glass_pca_data, centers = k_glass, nstart = 50)
T2 <- Sys.time()
cat("Temps d'execution K-means Glass (PCA):", format(T2 - T1), "\n")
cat("Taille des clusters:\n")
print(km_glass_pca$size)
cat("WSS total:", km_glass_pca$tot.withinss, "\n")
cat("BSS/TSS ratio:", km_glass_pca$betweenss / km_glass_pca$totss, "\n")

png("results/glass_clusplot_pca.png", width = 800, height = 600)
clusplot(glass_pca_data, km_glass_pca$cluster,
         color = TRUE, shade = TRUE, labels = 2, lines = 0,
         main = "Glass - Clusplot (composantes principales)")
dev.off()
cat("[SAVE] glass_clusplot_pca.png\n")

sil_glass_pca <- silhouette(km_glass_pca$cluster, dist(glass_pca_data))
cat("Silhouette moyenne (PCA):", mean(sil_glass_pca[, 3]), "\n")

png("results/glass_silhouette_plot_pca.png", width = 800, height = 600)
p <- fviz_silhouette(sil_glass_pca) + labs(title = "Glass - Silhouette (composantes principales)")
print(p)
dev.off()
cat("[SAVE] glass_silhouette_plot_pca.png\n")

# --- 2.5 Selection d'attributs ---
cat("\n--- Selection d'attributs sur Glass ---\n")

T1 <- Sys.time()
result_glass <- cfs(Type ~ ., Glass)
T2 <- Sys.time()
cat("Temps d'execution selection CFS:", format(T2 - T1), "\n")
cat("Attributs selectionnes:\n")
print(result_glass)

f_glass <- as.simple.formula(result_glass, "Type")
cat("Formule:\n")
print(f_glass)

glass_selected <- Glass[, result_glass]
glass_selected_scaled <- scale(glass_selected)

# --- 2.6 Clustering sur donnees selectionnees ---
cat("\n--- Clustering K-means sur Glass (attributs selectionnes) ---\n")

png("results/glass_elbow_selected.png", width = 800, height = 600)
p <- fviz_nbclust(glass_selected_scaled, kmeans, method = "wss") +
  labs(title = "Glass - Methode Elbow (attributs selectionnes)")
print(p)
dev.off()
cat("[SAVE] glass_elbow_selected.png\n")

T1 <- Sys.time()
km_glass_selected <- kmeans(glass_selected_scaled, centers = k_glass, nstart = 50)
T2 <- Sys.time()
cat("Temps d'execution K-means Glass (selected):", format(T2 - T1), "\n")
cat("Taille des clusters:\n")
print(km_glass_selected$size)
cat("WSS total:", km_glass_selected$tot.withinss, "\n")
cat("BSS/TSS ratio:", km_glass_selected$betweenss / km_glass_selected$totss, "\n")

png("results/glass_clusplot_selected.png", width = 800, height = 600)
clusplot(glass_selected_scaled, km_glass_selected$cluster,
         color = TRUE, shade = TRUE, labels = 2, lines = 0,
         main = "Glass - Clusplot (attributs selectionnes)")
dev.off()
cat("[SAVE] glass_clusplot_selected.png\n")

sil_glass_selected <- silhouette(km_glass_selected$cluster, dist(glass_selected_scaled))
cat("Silhouette moyenne (selected):", mean(sil_glass_selected[, 3]), "\n")

png("results/glass_silhouette_plot_selected.png", width = 800, height = 600)
p <- fviz_silhouette(sil_glass_selected) + labs(title = "Glass - Silhouette (attributs selectionnes)")
print(p)
dev.off()
cat("[SAVE] glass_silhouette_plot_selected.png\n")

# --- 2.7 Comparaison des resultats Glass ---
cat("\n\n========== COMPARAISON DES RESULTATS GLASS ==========\n")
cat(sprintf("%-25s | %-10s | %-10s | %-10s\n", "Methode", "WSS", "BSS/TSS", "Silhouette"))
cat(paste(rep("-", 65), collapse = ""), "\n")
cat(sprintf("%-25s | %-10.2f | %-10.4f | %-10.4f\n",
            "Donnees originales",
            km_glass_original$tot.withinss,
            km_glass_original$betweenss / km_glass_original$totss,
            mean(sil_glass_original[, 3])))
cat(sprintf("%-25s | %-10.2f | %-10.4f | %-10.4f\n",
            "Composantes principales",
            km_glass_pca$tot.withinss,
            km_glass_pca$betweenss / km_glass_pca$totss,
            mean(sil_glass_pca[, 3])))
cat(sprintf("%-25s | %-10.2f | %-10.4f | %-10.4f\n",
            "Attributs selectionnes",
            km_glass_selected$tot.withinss,
            km_glass_selected$betweenss / km_glass_selected$totss,
            mean(sil_glass_selected[, 3])))

cat("\n\n========== FIN DE L'ANALYSE ==========\n")
cat("Tous les graphiques et le log ont ete sauvegardes dans le dossier 'results/'\n")

# --- Fin du Logging ---
sink() # Desactive la redirection vers le fichier
cat("\n[LOG] Analyse terminee avec succes.\n")
