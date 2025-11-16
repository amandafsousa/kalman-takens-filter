function [filteredTimeSeries, var, Q, R] = KalmanTakensFilter (timeSeries, delays, kNN, Q_param, stationarity)
%KalmanTakensFilter Kalman-Takens filtering for NxT time series.
% Inputs:
%  timeSeries: NxT (rows = variables, cols = time);
%  delays: number of delays for Takens embedding (>= 1);
%  kNN: number of nearest neighbors for nonparametric dynamics (>= 1);
%  Q_param: 0 = none, 1 = full, 2 = alpha*I, 3 = diagonal;
%  stationarity: window length for adaptively averaging Q and R.
% Outputs:
%  filteredTimeSeries: NxT filtered signal;
%  var, Q, R: outputs from AUKF.
% Notes:
%  Uses NonParametricDynamics/Obs with TakensEmbedding, then AUKF;
%  Keep the same call signature used in the thesis scripts.

    if (nargin < 5), stationarity = 2000; end
    if (nargin < 4), Q_param = 0; end

    N = size (timeSeries, 1);
    trainingData = TakensEmbedding (timeSeries, delays);
    f = @ (x) NonParametricDynamics (x, trainingData, kNN, 0, 1, 50); % Nonparametric dynamics
    h = @ (x) NonParametricObs (x, delays); % Nonparametric observation
    state = trainingData (:, 1); % Initial state

    [filteredTimeSeries, var, Q, R] = AUKF (state, timeSeries, f, h, Q_param, stationarity);
    filteredTimeSeries = filteredTimeSeries (1:N,:);
end
