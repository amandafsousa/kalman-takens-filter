function delaySeries = TakensEmbedding (timeSeries, delays)
%TakensEmbedding Constructs a Takens time delay embedding of a time series.
% Inputs:
%  timeSeries: N-by-T matrix containing the original time series (N = number of variables, T = number of time samples);
%  delays: number of delay coordinates to include in the embedding.
% Output:
%  delaySeries: (N*delays)-by-(T-(delays-1)) matrix containing the Takens embedded version of the input time series.
% Description:
%  This function constructs the Takens embedding of a multivariate time series. Each delayed copy of the original signal is stacked vertically, producing a higher dimensional representation that captures the systems state space structure;
%  The output matrix will have N * delays rows and (T-(delays-1)) columns.
% See also: NonParametricDynamics, NonParametricObs, KalmanTakensFilter

    delaySeries = [];

    for i = delays:-1:1
        delaySeries = [delaySeries; timeSeries(:,i:end-(delays-i))];
    end
end
