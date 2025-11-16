\# Dataset documentation

This directory contains the time series datasets used in the implementation and experiments of the Kalman–Takens Filter (KTF) presented in the M.Sc. dissertation “Time Series Analysis in Mobile Communication Systems” at University of Campinas (UNICAMP), 2024.

The files stored here are pre-processed versions of publicly available 5G traffic datasets.





\## Dataset attribution (Required — CC BY 4.0)

The original datasets come from:

Kim, Daegyeom.
“5G Traffic Datasets.” Kaggle, 2023.
Available at: https://www.kaggle.com/datasets/kimdaegyeom/5g-traffic-datasets
License: Creative Commons Attribution 4.0 International (CC BY 4.0).

This repository redistributes resampled versions of the original data in full compliance with the CC BY 4.0 license, including proper attribution.





\## Pre-processing before applying the KTF

As described in Chapter 3 – Materials and Methods of the dissertation, all datasets underwent a necessary pre-processing stage prior to applying the KTF.





\## Purpose of pre-processing



The original CSV files contain irregular timestamp intervals, which are common in real world network measurements.


However, the KTF requires uniformly sampled time series for:

\- Takens Embedding;

\- State reconstruction;

\- Consistent forecasting;

\- Correct operation of the nonparametric model.



Therefore, each dataset was resampled using MATLABs 'retime' function to create regular time intervals.





\## Resampling intervals used



Different platforms exhibit different traffic dynamics; therefore, each time series was resampled with an interval appropriate to its variability:



| Platform  | Resampling interval | Rationale                          | Final number of samples |
| AfreecaTV | 5 seconds           | Moderate variability               | 9652                    |
| MS Teams  | 0.5 second          | High frequency, rapid fluctuations | 5189                    |
| YouTube   | 10 seconds          | Smoother rate of change in traffic | 5892                    |



After resampling, all datasets became uniform, consistent, and ready for KTF.





\## Files included in this directory



\- 'Serie\_AfreecaTV\_2\_tt\_rt\_five\_sec\_without\_nan.csv';

\- 'Serie\_MSTeams\_1\_tt\_five\_dec\_sec.csv';

\- 'Serie\_YouTube\_1\_tt\_ten\_sec\_without\_nan.csv'.



Each file is a cleaned and resampled version of the corresponding original dataset.





\## How these datasets are used in the Project



These data files are used by:

\- 'main.m';

\- The modules under 'src/'.



To reproduce the experiments and demonstrations of the KTF.





\## Redistribution notice



The datasets were originally released under the CC BY 4.0 license, which allows:

\- Copying;

\- Redistribution;

\- Modification;

\- Use in research and software.



As long as proper attribution is provided.



This repository includes modified versions of the datasets (resampled), and clearly attributes the original author in accordance with CC BY 4.0.

