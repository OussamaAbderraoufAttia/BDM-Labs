import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.experimental import enable_iterative_imputer
from sklearn.impute import IterativeImputer
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score, adjusted_rand_score
from sklearn.feature_selection import mutual_info_classif
import os
import urllib.request
import warnings
warnings.filterwarnings('ignore')

# Global configuration
RESULTS_DIR = "results"
os.makedirs(RESULTS_DIR, exist_ok=True)
sns.set_theme(style="whitegrid")

def save_plot(name):
    plt.tight_layout()
    plt.savefig(os.path.join(RESULTS_DIR, name), dpi=300)
    plt.close()

# ---------------------------------------------------------
# 1. Missing Value Treatment (Exercise 1: Air Quality)
# ---------------------------------------------------------
print("--- Exercise 1: Air Quality ---")
# Load dataset
aq_df = pd.read_csv("airquality.csv")
# Identify missing values
missing_counts = aq_df.isnull().sum()
missing_counts.to_frame(name="Missing Values").to_csv(os.path.join(RESULTS_DIR, "aq_missing_counts.csv"))

# Focus on Ozone for imputation comparison
# Methods: Deletion, Mean, Median, Linear Regression (IterativeImputer)
ozone_orig = aq_df['Ozone'].dropna()
ozone_mean = aq_df['Ozone'].fillna(aq_df['Ozone'].mean())
ozone_median = aq_df['Ozone'].fillna(aq_df['Ozone'].median())

imputer_lr = IterativeImputer(random_state=42)
aq_imputed_lr = pd.DataFrame(imputer_lr.fit_transform(aq_df.drop(columns=['Unnamed: 0'], errors='ignore')), columns=aq_df.columns.drop('Unnamed: 0', errors='ignore'))
ozone_lr = aq_imputed_lr['Ozone']

# Plotting the distributions
plt.figure(figsize=(10, 6))
sns.kdeplot(ozone_orig, label='Original (Deleted NAs)', color='blue')
sns.kdeplot(ozone_mean, label='Mean Imputation', color='red', linestyle='--')
sns.kdeplot(ozone_median, label='Median Imputation', color='green', linestyle='-.')
sns.kdeplot(ozone_lr, label='Iterative/LR Imputation', color='purple', linestyle=':')
plt.title("Ozone Distribution: Missing Value Treatment Methods")
plt.xlabel("Ozone")
plt.ylabel("Density")
plt.legend()
save_plot("aq_ozone_imputation.png")

# ---------------------------------------------------------
# 2. Categorical Encoding & Standardization (Exercise 2: Iris)
# ---------------------------------------------------------
print("\n--- Exercise 2: Iris Encoding & Standardization ---")
iris_df = pd.read_csv("iris.csv")
iris_df = iris_df.drop(columns=['Id'], errors='ignore')

# One-Hot Encoding to avoid dummy variable trap
# 'drop_first=True' drops the first encoded column
iris_encoded = pd.get_dummies(iris_df, columns=['Species'], drop_first=True, dtype=int)
iris_encoded.head().to_csv(os.path.join(RESULTS_DIR, "iris_encoded_head.csv"), index=False)

# Standardization: Scaling features to mean 0, std 1
features = ['SepalLengthCm', 'SepalWidthCm', 'PetalLengthCm', 'PetalWidthCm']
X_iris = iris_df[features]
y_iris_labels = iris_df['Species']

# Convert labels to numerical for ARI
y_iris_num = y_iris_labels.astype('category').cat.codes

scaler = StandardScaler()
X_iris_scaled = scaler.fit_transform(X_iris)
X_iris_scaled_df = pd.DataFrame(X_iris_scaled, columns=features)
X_iris_scaled_df.describe().to_csv(os.path.join(RESULTS_DIR, "iris_scaled_desc.csv"))

# ---------------------------------------------------------
# 3. Dimensionality Reduction & Clustering (TP4: Iris & Ionosphere)
# ---------------------------------------------------------
print("\n--- TP4: Iris Clustering & PCA ---")
# PCA on Iris
pca = PCA(n_components=2)
X_iris_pca = pca.fit_transform(X_iris_scaled)
explained_var = sum(pca.explained_variance_ratio_) * 100
print(f"Iris PCA variance explained (2 components): {explained_var:.2f}%")

with open(os.path.join(RESULTS_DIR, "iris_pca_variance.txt"), "w") as f:
    f.write(f"Iris PCA variance explained (2 components): {explained_var:.2f}%\n")

plt.figure(figsize=(8, 6))
sns.scatterplot(x=X_iris_pca[:, 0], y=X_iris_pca[:, 1], hue=y_iris_labels, palette='viridis')
plt.title(f"Iris PCA Projection ({explained_var:.2f}% Variance)")
plt.xlabel("Principal Component 1")
plt.ylabel("Principal Component 2")
save_plot("iris_pca_projection.png")

# Optimal k using Elbow & Silhouette for Iris
inertia = []
sil_scores = []
K_range = range(2, 10)
for k in K_range:
    kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
    labels = kmeans.fit_predict(X_iris_scaled)
    inertia.append(kmeans.inertia_)
    sil_scores.append(silhouette_score(X_iris_scaled, labels))

fig, ax1 = plt.subplots(figsize=(10, 5))
ax1.plot(K_range, inertia, 'bo-', label='Inertia (Elbow)')
ax1.set_xlabel('Number of clusters (k)')
ax1.set_ylabel('Inertia', color='b')
ax1.tick_params('y', colors='b')

ax2 = ax1.twinx()
ax2.plot(K_range, sil_scores, 'ro-', label='Silhouette Score')
ax2.set_ylabel('Silhouette Score', color='r')
ax2.tick_params('y', colors='r')

plt.title("Elbow Method and Silhouette Score for Iris Dataset")
save_plot("iris_optimal_k.png")

# Feature Selection via Mutual Information
mi_scores = mutual_info_classif(X_iris_scaled, y_iris_num, random_state=42)
mi_df = pd.DataFrame({'Feature': features, 'MI Score': mi_scores}).sort_values(by='MI Score', ascending=False)
top_2_features = mi_df['Feature'].head(2).tolist()
X_iris_mi = X_iris_scaled_df[top_2_features].values

# K-Means Comparison setup
def evaluate_clustering(X, true_labels, n_clusters=3):
    kmeans = KMeans(n_clusters=n_clusters, random_state=42, n_init=10)
    pred_labels = kmeans.fit_predict(X)
    ari = adjusted_rand_score(true_labels, pred_labels)
    sil = silhouette_score(X, pred_labels)
    return ari, sil

results_iris = []
for name, data in [("Original Scaled", X_iris_scaled), ("PCA Reduced (2 components)", X_iris_pca), ("MI Selected (2 features)", X_iris_mi)]:
    ari, sil = evaluate_clustering(data, y_iris_labels, n_clusters=3)
    results_iris.append({"Method": name, "ARI": ari, "Silhouette Score": sil})

pd.DataFrame(results_iris).to_csv(os.path.join(RESULTS_DIR, "iris_clustering_results.csv"), index=False)

# --- Ionosphere Dataset ---
print("\n--- TP4: Ionosphere Dataset ---")
url = "https://archive.ics.uci.edu/ml/machine-learning-databases/ionosphere/ionosphere.data"
iono_file = "ionosphere.csv"
if not os.path.exists(iono_file):
    urllib.request.urlretrieve(url, iono_file)

iono_df = pd.read_csv(iono_file, header=None)
X_iono = iono_df.iloc[:, :-1].values
y_iono_labels = iono_df.iloc[:, -1].values
y_iono_num = pd.Series(y_iono_labels).astype('category').cat.codes

# Standartization
scaler_iono = StandardScaler()
X_iono_scaled = scaler_iono.fit_transform(X_iono)

# PCA
pca_iono = PCA(n_components=2)
X_iono_pca = pca_iono.fit_transform(X_iono_scaled)
explained_var_iono = sum(pca_iono.explained_variance_ratio_) * 100

with open(os.path.join(RESULTS_DIR, "iono_pca_variance.txt"), "w") as f:
    f.write(f"Ionosphere PCA variance explained (2 components): {explained_var_iono:.2f}%\n")

# MI Feature Selection (selecting top 2 for comparison)
mi_scores_iono = mutual_info_classif(X_iono_scaled, y_iono_num, random_state=42)
top_2_idx_iono = np.argsort(mi_scores_iono)[-2:]
X_iono_mi = X_iono_scaled[:, top_2_idx_iono]

# Evaluate
results_iono = []
# Ionosphere has 2 classes (good/bad)
for name, data in [("Original Scaled", X_iono_scaled), ("PCA Reduced (2 components)", X_iono_pca), ("MI Selected (2 features)", X_iono_mi)]:
    ari, sil = evaluate_clustering(data, y_iono_labels, n_clusters=2)
    results_iono.append({"Method": name, "ARI": ari, "Silhouette Score": sil})

pd.DataFrame(results_iono).to_csv(os.path.join(RESULTS_DIR, "iono_clustering_results.csv"), index=False)
print("\nScript completed successfully. Results saved in the 'results' directory.")
