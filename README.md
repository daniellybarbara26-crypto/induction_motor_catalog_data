# induction_motor_catalog_data
Digitized torque and current curves of three-phase induction motors extracted from manufacturer catalogs.
# Induction Motor Catalog Data
 
This repository contains the digitized dataset of torque-speed and current-speed characteristic curves for several three-phase induction motors (TIMs). 

The data provided here was extracted directly from official manufacturer catalogs (ABB and WEG).

## Dataset Structure
The repository contains `.xlsx` (Excel) files separated by manufacturer and motor power rating (e.g., 5 HP, 7.5 HP, 25 HP, 50 HP, 100 HP). For each motor, there are typically two files:
* `[manufacturer]_[power]_conjugado.xlsx` (Torque curve data)
* `[manufacturer]_[power]_corrente.xlsx` (Current curve data)

##  Data Filtering Script
Because manufacturers typically provide these curves only in graphical format, the numerical data was extracted using [WebPlotDigitizer](https://automeris.io/WebPlotDigitizer). To mitigate digitization noise, a moving-window quadratic polynomial filtering algorithm was applied before the parameter estimation process.

Included in this repository is the MATLAB/Octave script that performs this filtering:
* 📄 **`catalog_data_moving_window_filter.m`**: This script implements the moving-window methodology. It reads the raw extracted `.xlsx` files, applies the polynomial filter to smooth the curves, and converts the values into SI units.

##  Data Dictionary
Inside the Excel files, the data is organized in columns representing the operational points extracted from the catalog curves.

| Column Header | Description | Unit |
| :--- | :--- | :--- |
| `n/n_sinc [%]` | Rotor speed normalized by the synchronous speed. | % |
| `Torque [pu]` | Electromagnetic output torque. | p.u. (per-unit) |
| `Current [pu]` | Stator input current. | p.u. (per-unit) |

*Note: The abbreviation `sinc` stands for synchronous. To convert the speed percentage to slip ($s$), use the formula: $s = 1 - (\text{n/n\_sinc} / 100)$.*

##  Usage
Researchers and engineers are welcome to use this data to test their own parameter estimation algorithms, validate digital twin models, or study the steady-state behavior of induction machines.
