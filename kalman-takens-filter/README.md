# Kalman–Takens Filter (KTF)

MATLAB implementation of the KTF, a hybrid nonparametric filtering and prediction method that combines Takens embedding with Kalman filtering concepts for time series prediction in mobile communication systems.

This repository accompanies the M.Sc. dissertation “Time Series Analysis in Mobile Communication Systems” at the University of Campinas (Unicamp), 2024.


## Overview

This project provides implementations of:
- KTF for nonlinear, model free time series prediction;
- Adaptive Unscented Kalman Filter (AUKF) used for comparison and baseline evaluation;
- Utility functions for error computation and plotting;
- A main script that reproduces the experiments presented in the dissertation using real 5G traffic data.

The experiments use three 5G traffic scenarios:
- AfreecaTV, live streaming;
- MS Teams, real time videoconferencing;
- YouTube, video streaming.

Each dataset contains timestamped packet size measurements ('Length') used as input to Takens embedding and the KTF.


## Repository structure

```
kalman-takens-filter/
├─ README.md        # Main documentation
├─ LICENSE          # MIT license (project code)
├─ CITATION.cff     # Citation metadata
├─ .gitignore
│
├─ src/
│  ├─ KalmanTakens/ # Core Kalman–Takens implementations
│  ├─ AdaptiveUKF/  # Adaptive Unscented Kalman Filter (AUKF)
│  ├─ Util/         # Utilities for plotting and error computation
│  └─ main.m        # Reproduces dissertation experiments
│
└─ data/
   ├─ README.md     # Dataset description, attribution, and preprocessing
   ├─ Serie_AfreecaTV_2_tt_rt_five_sec_without_nan.csv
   ├─ Serie_MSTeams_1_tt_five_dec_sec.csv
   └─ Serie_YouTube_1_tt_ten_sec_without_nan.csv
```


## Requirements

- MATLAB R2023a or newer;
- Approximately 1 MB of disk space required for the full repository.


## Getting started

### 1. Clone the repository

```bash
git clone https://github.com/amandafsousa/kalman-takens-filter.git
cd kalman-takens-filter
```

### 2. Run the main in MATLAB

```matlab
run('src/main.m')
```

This script loads one of the provided datasets and runs the KTF end-to-end, generating the prediction plot.


## How it works

The main script invokes:
```matlab
KTFcore(FILE, COLUMN, filterRowFrom, filterRowTo, plotTitle, filterTransient, delays, kNN, N)
```

### Parameters

| Parameter                       | Description                               |
| 'FILE'                          | Path to the input CSV                     |
| 'COLUMN'                        | Column used in analysis ('Length')        |
| 'filterTransient'               | Number of initial samples ignored in RMSE |
| 'delays'                        | Number of delays for Takens embedding     |
| 'kNN'                           | Number of nearest neighbors               |
| 'N'                             | Number of state variables                 |
| 'filterRowFrom' / 'filterRowTo' | Row range to evaluate                     |

The filter reconstructs a state space using delayed coordinates, applies a nonparametric dynamical model based on nearest neighbors, and estimates the smoothed/predicted signal.


## Datasets

The '/data' directory contains preprocessed versions of publicly available 5G traffic datasets.
Full attribution and preprocessing details are provided in 'data/README.md'.

Dataset source:
Kim, Daegyeom. “5G Traffic Datasets.” Kaggle, 2023.
Licensed under CC BY 4.0.
https://www.kaggle.com/datasets/kimdaegyeom/5g-traffic-datasets
https://github.com/0913ktg/5G-Traffic-Generator


## Citation

If you use this project, please cite the dissertation:

English:
SOUSA, Amanda de Figueiredo. Time series analysis in mobile communication systems. 2024. Dissertation (master’s) — University of Campinas (UNICAMP), School of Technology, Limeira, SP, Brazil. Available at: https://hdl.handle.net/20.500.12733/21309.

Portuguese:
SOUSA, Amanda de Figueiredo. Análise de séries temporais em sistemas de comunicações móveis. 2024. Dissertação (mestrado) - Universidade Estadual de Campinas (UNICAMP), Faculdade de Tecnologia, Limeira, SP. Disponível em: https://hdl.handle.net/20.500.12733/21309.


## Author

Amanda Sousa
amandafsousa@proton.me
ORCID: https://orcid.org/0009-0008-7418-3088
Lattes: http://lattes.cnpq.br/1128157496646655
LinkedIn: https://www.linkedin.com/in/amandadfsousa
