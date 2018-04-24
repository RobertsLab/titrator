# Calibration Data
Directory for storing daily calibration data files.

---
```daily_calibration_log.csv``` - Provides summary info for each pH calibration run. Data is appended to file by the [pH_calibration_check.R script](https://github.com/RobertsLab/titrator/blob/master/scripts/pH_calibration_check.R).

Stores the following info:
    - date: Date values were collected.
    - mean_E_pH3.5(mV): Mean voltage for pH = 3.5.
    - mean_E_pH3.0(mV): Mean voltage for pH = 3.0.
    - source_filename: Name of source file for data in this table.

The information in this table is needed by the [TA_calculation.R script](https://github.com/RobertsLab/titrator/blob/master/scripts/TA_calculation.R).
