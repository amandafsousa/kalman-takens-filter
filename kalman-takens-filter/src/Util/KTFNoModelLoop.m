function [noModSignal, stateEstimateNoModel] = KTFNoModelLoop (filterTransient, delays, kNN, obs, N)
%KTFNoModelLoop Run the Kalman–Takens filter (no model case) over N states.
% Inputs:
%  filterTransient : number of initial samples to discard when computing RMSE;
%  delays: number of delays in the Takens embedding;
%  kNN: number of nearest neighbors to use in forecast;
%  obs: N-by-T test signal (rows = states/variables);
%  N: number of state variables (rows in obs to filter).
% Outputs:
%  noModSignal: scalar RMSE between obs and stateEstimateNoModel over samples [filterTransient:end];
%  stateEstimateNoModel: N-by-T filtered estimates (no-model Kalman-Takens).

    % Run a separate Kalman Takens filter for each state/row in obs
    for i = 1:N
        % Use only the i-th state (univariate time series)
        timeSeries = obs (i,:);

        % Run the Kalman Takens Filter (no explicit model)
        stateEstimatei = KalmanTakensFilter (timeSeries, delays, kNN);

        % First component of the Kalman Takens output corresponds to the i-th state
        stateEstimateNoModel (i,:) = stateEstimatei (1,:);
    end

    % Root Mean Squared Error (RMSE) after the transient period
    noModSignal = sqrt (mean (mean ((stateEstimateNoModel (:, filterTransient:end) - obs(:, filterTransient:end)).^2)));
end
