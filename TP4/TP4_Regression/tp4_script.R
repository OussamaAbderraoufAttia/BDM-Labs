##############################################################################
# TP 4 : Regression Lineaire et Descente de Gradient
# Dataset : cars
##############################################################################

# --- Dossier de travail et creation des dossiers ---
try({
  setwd("c:/Users/s/BDM/TP4/TP4_Regression")
}, silent = TRUE)

if (!dir.exists("results")) dir.create("results", recursive = TRUE)

# --- Activation du Logging ---
log_file <- "results/log_tp4.txt"
sink(log_file, append = FALSE, split = TRUE)

cat("\n[LOG] Analyse TP4 lancee le :", as.character(Sys.time()), "\n")
cat("[LOG] Dossier de travail :", getwd(), "\n")

# Chargement du dataset
data(cars)
cat("\n======================================================\n")
cat("   EXERCICE 1 : REGRESSION LINEAIRE SIMPLE\n")
cat("======================================================\n\n")

cat("--- Dimensions et Resume du dataset 'cars' ---\n")
print(dim(cars))
print(summary(cars))
print(str(cars))

# Sauvegarde des donnees pour reference
write.csv(cars, "results/cars_data.csv", row.names = FALSE)

# --- 1. Visualisation du nuage de points ---
png("results/1_nuage_points_original.png", width = 800, height = 600)
plot(cars, xlab = "Speed (mph)", ylab = "Stopping distance (ft)", las = 1,
     main = "Relation Vitesse / Distance d'arret")
lines(lowess(cars$speed, cars$dist, f = 2/3, iter = 3), col = "red", lwd = 2)
dev.off()
cat("[SAVE] 1_nuage_points_original.png genere\n")

# --- 3. Regression lineaire simple ---
cat("\n--- Regression Lineaire: speed ~ dist ---\n")
reg <- lm(speed ~ dist, data = cars)
print(summary(reg))

png("results/2_regression_lineaire.png", width = 800, height = 600)
plot(cars$dist, cars$speed, xlab = "Stopping distance (ft)", ylab = "Speed (mph)", las = 1,
     main = "Regression Lineaire (speed ~ dist)")
abline(reg, col = "blue", lwd = 2)
dev.off()
cat("[SAVE] 2_regression_lineaire.png genere\n")

# --- 5 & 6. Transformation logarithmique ---
cat("\n--- Transformation Logarithmique ---\n")
png("results/3_nuage_points_log.png", width = 800, height = 600)
plot(cars, xlab = "Speed (mph)", ylab = "Stopping distance (ft)", las = 1, log = "xy",
     main = "Relation avec \'echelle logarithmique (log-log)")
lines(lowess(cars$speed, cars$dist, f = 2/3, iter = 3), col = "red", lwd = 2)
dev.off()
cat("[SAVE] 3_nuage_points_log.png genere\n")

# --- 7. Regression lineaire sur donnees log ---
cat("\n--- Regression Lineaire Log: log(speed) ~ log(dist) ---\n")
reg_log <- lm(log(speed) ~ log(dist), data = cars)
print(summary(reg_log))

png("results/4_regression_log.png", width = 800, height = 600)
plot(log(cars$dist), log(cars$speed), xlab = "log(Stopping distance)", ylab = "log(Speed)", las = 1,
     main = "Regression Lineaire Logarithmique")
abline(reg_log, col = "darkgreen", lwd = 2)
dev.off()
cat("[SAVE] 4_regression_log.png genere\n")

cat("\n======================================================\n")
cat("   EXERCICE 2 : DESCENTE DE GRADIENT\n")
cat("======================================================\n\n")

# Definition des variables
X <- cars$speed  # On choisit Speed = X (car on cherche generalement a predire dist a partir de speed, ou inversement, l'enonce considere X)
y <- cars$dist   # On choisit Dist = Y

# Standardisation OBLIGATOIRE des donnees car alpha = 0.01 est trop grand
# pour des donnees allant jusqu'a 120 (cela va diverger instantanement).
# On standardise X et y pour que la descente de gradient converge avec alpha=0.01
X_scaled <- as.numeric(scale(X))
y_scaled <- as.numeric(scale(y))
m <- length(y_scaled)

cat("Attention: Pour eviter la divergence de l'algorithme avec alpha=0.01,\n")
cat("les donnees X (speed) et Y (dist) ont ete standardisees (moyenne=0, ecart-type=1).\n\n")

# --- 1. Implementation de la descente de gradient ---
alpha <- 0.01
iterations <- 1000

# Parametres initiaux
p0 <- 0
p1 <- 0

# Stockage pour l'historique
cout_historique <- numeric(iterations)
p0_historique <- numeric(iterations)
p1_historique <- numeric(iterations)

# Fonction de cout J(P)
calcul_cout <- function(X, y, p0, p1) {
  hypothese <- p0 + p1 * X
  (1 / (2 * m)) * sum((hypothese - y)^2)
}

cat("--- Execution de la Descente de Gradient (classique) ---\n")
for (i in 1:iterations) {
  # Calcul de l'hypothese h(x)
  h <- p0 + p1 * X_scaled
  
  # Calcul des gradients (derivees partielles)
  grad_p0 <- (1 / m) * sum(h - y_scaled)
  grad_p1 <- (1 / m) * sum((h - y_scaled) * X_scaled)
  
  # Mise a jour des poids
  p0 <- p0 - alpha * grad_p0
  p1 <- p1 - alpha * grad_p1
  
  # Sauvegarde de l'historique
  cout_historique[i] <- calcul_cout(X_scaled, y_scaled, p0, p1)
  p0_historique[i] <- p0
  p1_historique[i] <- p1
}

cout_minimal <- cout_historique[iterations]
cat("Meilleurs parametres trouves : p0 (intercept) = ", p0, ", p1 (slope) = ", p1, "\n")
cat("Cout minimal atteint : ", cout_minimal, "\n")

# Trace de la convergence (Exercice 2.2)
png("results/5_convergence_gradient.png", width = 800, height = 600)
plot(1:iterations, cout_historique, type = "l", col = "blue", lwd = 2,
     xlab = "Iterations", ylab = "Cout J(P)",
     main = "Convergence de la Descente de Gradient (alpha = 0.01)")
dev.off()
cat("[SAVE] 5_convergence_gradient.png genere\n")

# Comparaison avec lm() sur les donnees standardisees
lm_check <- lm(y_scaled ~ X_scaled)
cat("\nVerification (Verification avec lm() sur donnees scalees):\n")
print(coef(lm_check))


# --- 4. Descente de Gradient avec Regularisation (Penalite) ---
cat("\n--- Descente de Gradient avec Regularisation (L2 - Ridge) ---\n")

# On definit un parametre de regularisation lambda
lambda <- 0.5 

p0_reg <- 0
p1_reg <- 0
cout_historique_reg <- numeric(iterations)

calcul_cout_reg <- function(X, y, p0, p1, lambda) {
  hypothese <- p0 + p1 * X
  (1 / (2 * m)) * sum((hypothese - y)^2) + (lambda / (2 * m)) * sum(p1^2)
}

for (i in 1:iterations) {
  h <- p0_reg + p1_reg * X_scaled
  
  # Le gradient de l'intercept p0 n'est generalement PAS regularise
  grad_p0 <- (1 / m) * sum(h - y_scaled)
  
  # Le gradient de p1 est regularise (ajout de la derivee de la penalite)
  grad_p1 <- (1 / m) * sum((h - y_scaled) * X_scaled) + (lambda / m) * p1_reg
  
  p0_reg <- p0_reg - alpha * grad_p0
  p1_reg <- p1_reg - alpha * grad_p1
  
  cout_historique_reg[i] <- calcul_cout_reg(X_scaled, y_scaled, p0_reg, p1_reg, lambda)
}

cout_minimal_reg <- cout_historique_reg[iterations]
cat("Nouveaux parametres (L2, lambda=", lambda, ") : p0 = ", p0_reg, ", p1 = ", p1_reg, "\n")
cat("Remarque: La pente (p1) est plus petite en valeur absolue (shrinkage).\n")

# Affichage de la convergence avec regularisation
png("results/6_convergence_regularisation.png", width = 800, height = 600)
plot(1:iterations, cout_historique_reg, type = "l", col = "purple", lwd = 2,
     xlab = "Iterations", ylab = "Cout J(P) Regularise",
     main = "Convergence avec Regularisation (alpha = 0.01, lambda = 0.5)")
dev.off()
cat("[SAVE] 6_convergence_regularisation.png genere\n")

# Trace comparatif des deux droites sur le scatter plot
png("results/7_comparaison_droites.png", width = 800, height = 600)
plot(X_scaled, y_scaled, xlab = "Speed (Standardise)", ylab = "Distance (Standardise)",
     main = "Comparaison Droite Classique vs Regularisee")
abline(a = p0, b = p1, col = "blue", lwd = 2)          # Classique
abline(a = p0_reg, b = p1_reg, col = "purple", lwd = 2) # Regularisee
legend("topleft", legend = c("Sans regularisation", "Avec regularisation (L2)"),
       col = c("blue", "purple"), lwd = 2)
dev.off()
cat("[SAVE] 7_comparaison_droites.png genere\n")


cat("\n[LOG] Analyse TP4 terminee avec succes.\n")
sink()
