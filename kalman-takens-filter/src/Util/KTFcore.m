function [] = KTFcore (FILE, COLUMN, filterRowsFrom, filterRowsTo, plotTitle, filterTransient, delays, kNN, N)
%KTFcore Core wrapper for running the Kalman Takens filter (no model case).
% Inputs:
%  FILE: path to timetable CSV file;
%  COLUMN: column name in the table to extract as signal;
%  filterRowsFrom: first row to include (if both > 0);
%  filterRowsTo: last row to include  (if both > 0);
%  plotTitle: base name for figure window;
%  filterTransient: number of initial samples to discard when computing errors;
%  delays: number of delays for Takens embedding;
%  kNN: number of nearest neighbors in nonparametric model;
%  N: number of state variables.
% Description:
%  Reads data from a timetable, optionally filters the rows, extracts a column as a univariate signal, runs the Kalman-Takens filter in 'no model' mode, computes results, and produces comparison plots.

    % Load timetable
    tt = readtimetable (FILE);

    % Optional row filtering
    if filterRowsFrom > 0 && filterRowsTo > 0
       Ttbl = timetable2table (tt (filterRowsFrom:filterRowsTo, :));
    else
       Ttbl = timetable2table (tt);
    end

    % Extract selected column as row vector
    a = table2array (Ttbl (:, COLUMN));
    tstSig = a';
    T = length (tstSig);

    % Observations
    obs = tstSig;

    % Run Kalman Takens no model filter
    tic; [noModSignal, stateEstimateNoModel] = KTFNoModelLoop (filterTransient, delays, kNN, obs, N);
    fprintf (strcat(plotTitle, ' finished in: \t', string(toc), '\n'));

    % Construct detailed plot title
    plotTitle = strcat (plotTitle, '[KNN:', string (kNN), '|delay:', string (delays), '|Transient Filter:', string (filterTransient), '|RMSE:', string (noModSignal), ']');

    % Plot results
    ComputeErrorsPlotResults (T, plotTitle, obs, stateEstimateNoModel);

    % Save outputs
    save ('obs.mat', 'obs');
    save ('stateEstimateNoModel.mat','stateEstimateNoModel');
end
