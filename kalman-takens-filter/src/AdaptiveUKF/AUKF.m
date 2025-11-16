function [stateEstimate, varEstimate, Q, R] = AUKF (state, obs, f, h, Q_param, stationarity, Q, R)
%AUKF Adaptive Unscented Kalman Filter loop with online Q/R estimation.
% Inputs:
%  state: Nx1 initial state estimate (x0);
%  obs: MxT observation matrix (each column y_t ∈ R^M);
%  f: handle for state dynamics, f(x);
%  h: handle for observation model, h(x);
%  Q_param: process noise structure, 0 = none (do not adapt), 1 = full, 2 = multiple of identity, 3 = diagonal;
%  stationarity: window length for adaptive averaging of Q and R;
%  Q (optional): initial NxN process noise covariance (default: I_N);
%  R (optional): initial MxM measurement noise covariance (default: I_M).
% Outputs:
%  stateEstimate: NxT filtered state mean per time step;
%  varEstimate: NxT diagonal of state covariance (per time step);
%  Q, R: final process/measurement covariance estimates.
% Notes:
%  The per step update is delegated to AUKF_STEP, which returns the updated state/covariance and instantaneous Qest/Rest estimates;
%  Q/R are recursively averaged with 'stationarity' after a short burn-in;
%  This function expects obs(:,t) to be the measurement at time t.
% See also: AUKF_STEP.

    N = size (state, 1);
    M = size (obs, 1);
    T = size (obs, 2);

    if nargin < 8, R = eye (M); end
    if nargin < 7, Q = eye (N); end
    if nargin < 6, stationarity = 2000; end
    if nargin < 5, Q_param = 1; end

    covmat = eye(N);

    stateEstimate = zeros (N, T);
    varEstimate = zeros (N, T);
    prev_innov = zeros (M, 1);
    prev_FPF = eye (N);

    stateEstimate (:,1) = state;

    for t = 1:T-1
        [state, covmat, Qest, Rest, prev_innov, prev_FPF] = AUKF_STEP (state, covmat, obs (:,t+1), f, h, Q, R, Q_param, prev_innov, prev_FPF);

        stateEstimate (:,t+1) = state;
        varEstimate (:,t+1) = diag (covmat);

        if Q_param > 0
            if t > 20
                Q = (Q * (2 * stationarity - 1) + Qest) / (2 * stationarity);
                R = (R * (stationarity - 1) + Rest) / (stationarity);
            end
        end
    end

    % Symmetrize final Q and R to guard against numerical drift
    [U, S, ~] = svd (Q); Q = U * S * U';
    [U, S, ~] = svd (R); R = U * S * U';
end
