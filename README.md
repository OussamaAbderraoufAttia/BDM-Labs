# BDM Labs - Big Data Mining & Machine Learning

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.7%2B-blue.svg)](#)
[![R](https://img.shields.io/badge/R-4.0%2B-blue.svg)](#)
[![Year: 2025-2026](https://img.shields.io/badge/Year-2025--2026-green.svg)](#)

## 📚 About

This repository contains comprehensive practical work and projects for the **Big Data Mining & Machine Learning** course taught at **ESI (École Nationale Supérieure d'Informatique)**.

**Course Instructor:** HAMDAD Leila  
**Student:** Oussama Abderraouf ATTIA  
**Specialization:** SIL (Systèmes Informatiques et Logiciels)  
**Academic Year:** 2025-2026  
**Institution:** ESI - École Nationale Supérieure d'Informatique

---

## 🎯 Course Objectives

This course aims to:

1. **Familiarize with Big Data** - Understand big data concepts and development environments
2. **Master Big Data Analysis Process** - Learn data generation, acquisition, analysis, and processing workflows
3. **Apply Machine Learning Methods** - Develop and implement ML algorithms for big data analysis
4. **Efficient Data Extraction** - Extract relevant information from large datasets in reasonable timeframes
5. **Build Big Data Analytics Projects** - Develop complete analytical projects with modern technologies on large-scale datasets

---

## 📖 Course Syllabus

### **Foundations**
- **Chapter 1:** Data Mining Fundamentals
- **Chapter 2:** Introduction to Big Data
- **Chapter 3:** Introduction to Machine Learning
- **Chapter 4:** Machine Learning Challenges (underfitting, overfitting, no free lunch, feature engineering, etc.)

### **Supervised Learning**
- **Chapter 5:** Decision Trees & Random Forest
- **Chapter 6:** Naive Bayes Classifier & Regression Models (Linear, Generalized, Logistic)
- **Chapter 7:** Support Vector Machines (SVM) & Neural Networks

### **Unsupervised Learning**
- **Chapter 6:** Clustering Algorithms
- **Chapter 7:** Association Rules
- **Chapter 8:** Feature Selection & Dimensionality Reduction

### **Practical Application**
All methods covered in lectures are applied to datasets of varying sizes in practical sessions (TP). Results are interpreted and analyzed. Tools used: **R** and **Python**.

---

## �️ Technologies & Tools Used

### **Programming Languages**
- **Python 3.7+**
  - NumPy - Numerical computing
  - Pandas - Data manipulation and analysis
  - Scikit-learn - Machine learning algorithms
  - Matplotlib & Seaborn - Data visualization
  - SciPy - Scientific computing

- **R 4.0+**
  - ggplot2 - Advanced visualization
  - caret - Machine learning framework
  - dplyr - Data manipulation
  - Other statistical packages

### **Data Formats**
- CSV (Comma-Separated Values)
- TXT (Log files and results)
- JSON (configuration and metadata)

### **Documentation**
- LaTeX for generating professional reports (`.tex` files)
- Markdown for documentation

---

## 📁 Repository Structure

```
BDM-Labs/
├── TP3/                              # Practical Work 3: Data Mining & Clustering
│   ├── script.py                     # Main Python analysis script
│   ├── topdf.py                      # PDF generation utility
│   ├── report.tex                    # LaTeX report with visualizations
│   ├── airquality.csv                # Air quality dataset (UCI)
│   ├── ionosphere.csv                # Ionosphere dataset (UCI)
│   ├── iris.csv                      # Iris dataset (Classic)
│   ├── Rapport/                      # Report materials
│   └── results/                      # Analysis outputs
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
│   │   ├── analysis.R                # R implementation of clustering
│   │   ├── report.tex                # LaTeX report
│   │   └── results/
│   │       ├── glass_data.csv
│   │       ├── iris_data.csv
│   │       └── log_results.txt
│   │
│   └── TP4_Regression/               # Regression Analysis & Supervised Learning
│       ├── tp4_script.R              # R regression analysis script
│       ├── tp4_report.tex            # LaTeX report with results
│       └── results/
│           ├── cars_data.csv         # Regression dataset
│           └── log_tp4.txt           # Execution logs and results
│
├── README.md                         # This file
└── .gitignore

```

---

## 🎯 Progress & Work Completed

### TP3: Data Mining Fundamentals & Clustering (Unsupervised Learning)
**Status:** ✅ Completed

**Topics Covered:**
- Data preprocessing and cleaning
- Handling missing values and data quality
- Exploratory Data Analysis (EDA)
- Principal Component Analysis (PCA) for dimensionality reduction
- Clustering algorithms implementation (K-means)
- Feature selection and data transformation

**Techniques Applied:**
- Data visualization and interpretation
- Variance analysis through PCA
- Multi-dataset clustering analysis
- Statistical interpretation of results

**Datasets Used:**
- Iris dataset (150 samples, 4 features)
- Air Quality dataset (with missing values analysis)
- Ionosphere dataset (binary classification problem)

**Key Outputs:**
- Clustering results and cluster assignments
- PCA variance explained analysis
- Missing values analysis
- Data scaling and normalization results
- Comprehensive LaTeX reports with visualizations

---

### TP4: Advanced Analysis & Regression (Supervised Learning)
**Status:** ✅ In Progress/Completed

#### **TP3_Bis:** Extended Unsupervised Learning Analysis (R Implementation)
- Re-implementation of clustering algorithms using R
- Advanced statistical analysis with R libraries (ggplot2, caret, dplyr)
- Glass and Iris dataset extended analysis
- Comparative analysis between Python and R implementations
- Enhanced visualization and statistical testing

#### **TP4_Regression:** Supervised Learning - Regression Analysis
**Topics Covered:**
- Linear regression models
- Generalized and logistic regression
- Model evaluation metrics and performance assessment
- Hypothesis testing and statistical validation
- Cross-validation techniques

**Datasets Used:**
- Cars dataset (regression problem)
- Model performance logging

**Key Outputs:**
- Regression model results
- Performance metrics and evaluation logs
- Comparative analysis of different regression models

---

## 📊 Key Techniques & Algorithms Covered

### **Data Mining & Preprocessing**
✓ Data cleaning and quality assessment  
✓ Missing value handling  
✓ Data normalization and scaling  
✓ Exploratory Data Analysis (EDA)  

### **Unsupervised Learning**
✓ Clustering (K-means)  
✓ Dimensionality Reduction (PCA)  
✓ Feature Selection  
✓ Association Rules (theory)  

### **Supervised Learning** 
✓ Regression Models (Linear, Generalized, Logistic)  
✓ Naive Bayes Classifier (theory/implementation)  
✓ Decision Trees & Random Forests (upcoming)  
✓ Support Vector Machines (upcoming)  
✓ Neural Networks (upcoming)  

### **Machine Learning Fundamentals**
✓ Underfitting & Overfitting concepts  
✓ Feature Engineering  
✓ Cross-validation and model evaluation  
✓ No Free Lunch theorem  

---

## 📝 Note on TP0-2

Earlier practical assignments (TP0-2) focused on foundational concepts and prerequisite material. These are not included in this repository as they were introductory in nature and have been superseded by the comprehensive applied work in TP3 and TP4.

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
**Email:** lo_attia@esi.dz 
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
