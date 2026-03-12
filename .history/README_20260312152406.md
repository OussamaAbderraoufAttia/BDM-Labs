# BDM Labs - Big Data Mining

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Year: 2025-2026](https://img.shields.io/badge/Year-2025--2026-blue.svg)](#)

## 📚 About

This repository contains practical work and projects for the **Big Data Mining (BDM)** course taught at **ESI (École Nationale Supérieure d'Informatique)**.

**Instructor:** HAMDAD Leila  
**Student:** Oussama Abderraouf ATTIA  
**Specialization:** SIL (Systèmes Informatiques et Logiciels)  
**Academic Year:** 2025-2026

---

## 📋 Project Overview

This course focuses on fundamental concepts and techniques in big data mining, including data preprocessing, exploratory data analysis, clustering, dimensionality reduction, and regression analysis. Each practical assignment builds upon previous concepts to develop a comprehensive understanding of data mining methodologies.

---

## 📁 Repository Structure

```
BDM-Labs/
├── TP3/                              # Practical Work 3: Data Mining & Clustering
│   ├── script.py                     # Main Python analysis script
│   ├── topdf.py                      # PDF generation utility
│   ├── report.tex                    # LaTeX report
│   ├── airquality.csv                # Air quality dataset
│   ├── ionosphere.csv                # Ionosphere dataset
│   ├── iris.csv                      # Iris dataset
│   ├── Rapport/                      # Report materials
│   └── results/                      # Analysis results
│       ├── aq_missing_counts.csv     # Missing values analysis
│       ├── iono_clustering_results.csv
│       ├── iono_pca_variance.txt
│       ├── iris_clustering_results.csv
│       ├── iris_encoded_head.csv
│       ├── iris_pca_variance.txt
│       └── iris_scaled_desc.csv
│
├── TP4/                              # Practical Work 4: Advanced Analysis & Regression
│   ├── Rapports/                     # Report materials
│   ├── TP3_Bis/                      # Extended TP3 Analysis (R)
│   │   ├── analysis.R                # R analysis script
│   │   ├── report.tex                # LaTeX report
│   │   └── results/
│   │       ├── glass_data.csv
│   │       ├── iris_data.csv
│   │       └── log_results.txt
│   │
│   └── TP4_Regression/               # Regression Analysis
│       ├── tp4_script.R              # R regression script
│       ├── tp4_report.tex            # LaTeX report
│       └── results/
│           ├── cars_data.csv
│           └── log_tp4.txt
│
├── README.md                         # This file
└── .gitignore

```

---

## 🎯 Progress & Work Completed

### TP3: Data Mining & Clustering
- **Objective:** Data preprocessing, exploration, and clustering analysis
- **Techniques Applied:**
  - Data cleaning and handling missing values
  - Exploratory Data Analysis (EDA)
  - Principal Component Analysis (PCA) for dimensionality reduction
  - K-means clustering on multiple datasets (Iris, Air Quality, Ionosphere)
  - Data visualization and interpretation
- **Datasets Used:**
  - Iris dataset
  - Air Quality dataset
  - Ionosphere dataset
- **Outputs:** Generated clustering results, PCA variance analysis, and comprehensive reports

### TP4: Advanced Analysis & Regression
- **TP3_Bis:** Extended analysis of TP3 work using R language
  - Re-implementation of clustering algorithms in R
  - Advanced statistical analysis
  - Glass and Iris data analysis
  
- **TP4_Regression:** Regression analysis and predictive modeling
  - Linear and non-linear regression models
  - Cars dataset regression analysis
  - Model evaluation and performance metrics
  - Statistical testing and validation

---

## 🛠️ Technologies & Tools

- **Languages:**
  - Python (NumPy, Pandas, Scikit-learn, Matplotlib, Seaborn)
  - R (ggplot2, caret, dplyr)
  
- **Data Formats:**
  - CSV (Comma-Separated Values)
  - TXT (Text logs)
  
- **Documentation:**
  - LaTeX for report generation

---

## 📊 Key Concepts Covered

- **Data Preprocessing**
  - Data cleaning
  - Handling missing values
  - Data normalization and scaling

- **Exploratory Data Analysis**
  - Descriptive statistics
  - Data visualization
  - Correlation analysis

- **Dimensionality Reduction**
  - Principal Component Analysis (PCA)
  - Variance analysis

- **Clustering Algorithms**
  - K-means clustering
  - Cluster evaluation metrics

- **Regression Analysis**
  - Linear regression
  - Model performance evaluation
  - Statistical significance testing

---

## 📝 Note on TP0-2

Earlier practical assignments (TP0-2) focused on foundational concepts and are not included in this repository as they were introductory in nature and have been superseded by the comprehensive work in TP3 and TP4.

---

## 🚀 Getting Started

### Prerequisites
- Python 3.7+
- R 4.0+
- Required Python packages: pandas, numpy, scikit-learn, matplotlib, seaborn
- Required R packages: ggplot2, caret, dplyr

### Running the Scripts

**Python Analysis (TP3):**
```bash
cd TP3
python script.py
python topdf.py  # Generate PDF reports
```

**R Analysis (TP4):**
```bash
cd TP4/TP3_Bis
Rscript analysis.R

cd ../TP4_Regression
Rscript tp4_script.R
```

---

## 📄 Documentation

Each practical work includes:
- **LaTeX Reports:** Comprehensive documentation of methodology and results
- **Result Files:** CSV and TXT outputs containing analysis results
- **Source Code:** Well-commented Python and R scripts

---

## 📞 Contact

**Student:** Oussama Abderraouf ATTIA  
**Email:** [Your Email Here]  
**Institution:** ESI (École Nationale Supérieure d'Informatique)

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- HAMDAD Leila for guidance and instruction
- ESI for providing the educational framework and resources
- The data mining community for foundational research and methodologies

---

**Last Updated:** March 2026
