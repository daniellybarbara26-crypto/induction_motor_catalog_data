% Clear command window, workspace variables, and close all figures
clc
clear all
close all

% Load the io package (required in Octave to read Excel files)
pkg load io

% =========================================================================
% MANUFACTURER DATA (Nominal parameters for the 50 HP WEG motor)
% =========================================================================
f1 = 60 ;         % Nominal grid frequency [Hz]
In = 126 ;        % Nominal stator current [A]
p = 6 ;           % Number of poles
nn = 1189 ;       % Nominal mechanical speed [rpm]
tnom = 297 ;      % Nominal electromagnetic torque [N.m]

% Calculate synchronous speed and nominal slip
ns = (120*f1)/p;                 % Synchronous speed [rpm]
sn = (ns-nn)/ns;                 % Nominal slip [p.u.]

% =========================================================================
% DATA EXTRACTION 
% Read the digitized data points (e.g., from WebPlotDigitizer)
% Column 1: Speed in % of synchronous speed, Column 2: Value in p.u.
% =========================================================================
data = xlsread('weg_50hp_conjugado.xlsx');  % Torque data
corrente = xlsread('weg_50hp_corrente.xlsx'); % Current data

% Initialize arrays to store the filtered and converted values
T_new_hist = [];
I_new_hist = [];

% Define the step size for the slip evaluation
passo = 0.01;

% Create an array of slip values from nominal slip to near stall (s = 0.99)
s_hist = sn:passo:0.99;

% =========================================================================
% MOVING-WINDOW QUADRATIC POLYNOMIAL FILTERING (Algorithm 1)
% =========================================================================
for s = sn:passo:0.99
    
    % Define the moving window half-width (Delta s = 0.02)
    % This creates the local neighborhood [s - 0.02, s + 0.02]
    s_var_max = s + 0.02;
    s_var_min = s - 0.02;
    
    % --- TORQUE FILTERING ---
    % 1. Convert x-axis data from speed percentage to slip: 1 - (data(:,1)/100)
    % 2. Find indices of points that fall within the moving window
    % 3. Fit a 2nd-order polynomial (polyfit) to the local data points
    p_T = polyfit(1-data((find(1-(data(:,1)/100)<s_var_max & (1-data(:,1)/100)>s_var_min)),1)/100, ...
                  data((find(1-(data(:,1)/100)<s_var_max & (1-data(:,1)/100)>s_var_min)),2), 2);
              
    % Evaluate the fitted polynomial at the central slip point 's'
    % Multiply by nominal torque to convert from p.u. to SI units (N.m)
    T_new = polyval(p_T, s) * tnom;
    
    % --- CURRENT FILTERING ---
    % Repeat the same process for the stator current data
    p_I = polyfit(1-corrente((find(1-(corrente(:,1)/100)<s_var_max & (1-corrente(:,1)/100)>s_var_min)),1)/100, ...
                  corrente((find(1-(corrente(:,1)/100)<s_var_max & (1-corrente(:,1)/100)>s_var_min)),2), 2);
              
    % Evaluate at central slip 's' and convert from p.u. to SI units (A)
    I_new = polyval(p_I, s) * In;
    
    % Store the filtered values in the history arrays
    T_new_hist = [T_new_hist T_new];
    I_new_hist = [I_new_hist I_new];
    
end

