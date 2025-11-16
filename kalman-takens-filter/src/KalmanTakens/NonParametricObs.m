function obs = NonParametricObs (state, delays)
%NonParametricObs Nonparametric observation function for Takens embedded states.
% Inputs:
%  state: M-by-T matrix representing the current Takens embedded state;
%  delays: number of delays used in the Takens embedding.
% Output:
%  obs: N-by-T matrix containing the observed variables.
% Description:
%  This function extracts the observed components from the full Takens embedded state vector. It assumes that the embedding was constructed by stacking delayed versions of the original N dimensional time series, such that every 'delays' th row corresponds to the same variable at successive delays;
%  In other words, given a state vector organized as: [x(t); x(t-τ); x(t-2τ); ...] this function returns only the current observation x(t).
% See also: TakensEmbedding, KalmanTakensFilter

    obs = state (1:delays:end,:);
end
