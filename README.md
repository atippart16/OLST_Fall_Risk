# Multimodal Sensor Fusion for Balance Instability Assessment

**INFO I-501 — Group 4**  
Akanksha Tipparti · Srilakshmi Maddipati · Vishnu Sudarsanan · Volga Yerukola

---

## Overview

This project evaluates whether **multimodal sensor fusion** improves the detection of balance instability during the **One-Legged Stand Test (OLST)** — a common clinical tool for fall-risk assessment.

Falls affect ~37.3 million people annually requiring medical attention. Traditional single-sensor approaches miss the full complexity of balance. We combine three sensor modalities — Motion Capture, Force Plate, and Radar — to build a more accurate, objective classifier.

---

## Dataset

**Multimodal Synchronized OLST Dataset** (publicly available via PhysioNet)

| Property | Value |
|---|---|
| Participants | 32 (young and older adults) |
| Trials | 1,241 OLST attempts |
| Motion Capture | 100 Hz — joint kinematics |
| Force Plate | 1200 Hz — ground reaction force & center of pressure |
| Radar | ~27 Hz — non-contact micro-motion sensing |

**Labels:** `STABLE` (t_stable is not NaN) vs `UNSTABLE` (t_stable is NaN). Class ratio ≈ 7:1.

---

## Repository Structure

```
├── feature_extraction/
│   ├── MOCAP_feature_extraction.ipynb      # 25 kinematic features from motion capture
│   ├── Forceplate_feature_extraction.ipynb # 16 kinetic features from force plates
│   ├── Radar_feature_extraction.ipynb      # 19 Doppler/micro-motion features from radar
│   └── Merge_extracted_features.ipynb      # Merges all modalities → OLST_Final_Merged.csv
│
├── ml_pipeline/
│   └── OLST_Full_Pipeline.ipynb            # EDA, SQL cleaning, ML models, evaluation
│
├── docs/
│   └── I501_Final_Presentation.pptx        # Final project presentation
│
└── README.md
```

---

## Features Extracted

| Modality | Count | Key Features |
|---|---|---|
| MOCAP | 25 | Knee velocity/acceleration (stance & lifted leg), CoM displacement, trunk sway |
| Force Plate | 16 | COP AP/ML range/mean/SD, COP speed, GRF-Z variability, sway path length |
| Radar | 19 | Doppler centroid, micro-velocity/acceleration, amplitude power/variation |
| **Total** | **60** | Merged on `OLST_attempt_id` |

---

## ML Pipeline

- **Data cleaning:** SQL-based removal of incomplete multimodal trials (1,241 → 1,224 rows)
- **Statistical testing:** Mann-Whitney U + FDR correction (41/60 features significant at p<0.05)
- **Models:** Logistic Regression, Random Forest, XGBoost — across 4 feature sets (MOCAP-only, ForcePlate-only, Radar-only, All fused)
- **Class imbalance:** `class_weight='balanced'` on all models

---

## Key Results

| Configuration | AUC | F1 | BAC |
|---|---|---|---|
| MOCAP + XGBoost (all features) | **0.966** | 0.795 | 0.888 |
| All sensors + XGBoost | 0.961 | 0.745 | — |
| All sensors + LogReg (Top-5) | 0.960 | — | **0.895** |
| ForcePlate + XGBoost | 0.916 | — | — |
| Radar + RandomForest (Top-5) | 0.821 | — | — |

**Conclusion:** H₀ retained — multimodal fusion did **not** significantly outperform the best single-modality model. MOCAP alone (AUC=0.966) outperforms fusion (AUC=0.961). Fusion helps weaker modalities (ForcePlate, Radar) but adds noise when MOCAP is already near-ceiling. Top-5 features lose <0.006 AUC vs. all 60, demonstrating highly efficient feature sets are viable.

---

## How to Run

### Setup

```bash
pip install numpy pandas scikit-learn xgboost scipy matplotlib seaborn
```

### Data

Download the PhysioNet dataset and set `dataset_path` in each notebook to your local copy:

```
multimodal-synchronized-motion-capture-force-plate-and-radar-dataset-of-the-one-legged-stand-test-for-fall-risk-assessment-1.0/
```

### Execution Order

1. `feature_extraction/MOCAP_feature_extraction.ipynb` → produces `mocap_features.csv`
2. `feature_extraction/Forceplate_feature_extraction.ipynb` → produces `fp_features.csv`
3. `feature_extraction/Radar_feature_extraction.ipynb` → produces `radar_features.csv`
4. `feature_extraction/Merge_extracted_features.ipynb` → produces `OLST_Final_Merged.csv`
5. `ml_pipeline/OLST_Full_Pipeline.ipynb` → full EDA + model training + evaluation

> **Note:** Notebooks were developed in Google Colab. Update file paths (`/content/drive/MyDrive/...`) to match your local environment if running locally.

---

## Course

INFO I-501 · Final Project · Group 4
