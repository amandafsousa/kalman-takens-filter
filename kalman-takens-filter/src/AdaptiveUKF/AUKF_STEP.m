function [xa, Pa, Qest, Rest, innov, FPF] = AUKF_STEP (xa, Pa, obs, f, h, Q, R, Q_param, prev_innov, prev_FPF)
%AUKF_STEP One step update for the Adaptive Unscented Kalman Filter.
% Inputs:
%  xa: Nx1 current state estimate;
%  Pa: NxN current state covariance;
%  obs: Mx1 observation at current time;
%  f: handle for nonlinear state dynamics, f(x);
%  h: handle for nonlinear observation model, h(x);
%  Q: NxN process-noise covariance;
%  R: MxM measurement-noise covariance;
%  Q_param: 0 = none, 1 = full, 2 = multiple of identity, 3 = diagonal;
%  prev_innov: Mx1 previous innovation (y_t−1 − ŷ_t−1);
%  prev_FPF: NxN previous FPF (state covariance of forecasted sigma points).
% Outputs:
%  xa: Nx1 updated state estimate (a posteriori);
%  Pa: NxN updated covariance (a posteriori);
%  Qest: NxN instantaneous estimate of process noise covariance;
%  Rest: MxM instantaneous estimate of measurement noise covariance;
%  innov: Mx1 innovation at current step (obs − ŷ);
%  FPF: NxN covariance of propagated sigma points (forecast).
% Notes:
%  Q/R are re-symmetrized here to avoid numerical asymmetry;
%  Qest/Rest are produced for the outer averaging loop (in AUKF.m);
%  This routine relies on: unscentedEnsemble, Qparamaterization.
% See also: AUKF, unscentedEnsemble.

warning ('off', 'MATLAB:rankDeficientMatrix');

    N = length (xa);
    M = length (obs);

    % Ensure Q and R are symmetric positive semidefinite (SVD symmetrization)
    [U, S, ~] = svd (Q); Q = U * S * U';
    [U, S, ~] = svd (R); R = U * S * U';

    % Unscented ensemble and weights (2N + 1 sigma points)
    [X, weights] = unscentedEnsemble (xa, Pa, sqrt (N - 1));
    weightMatrix = diag (weights (2:end)); % Exclude the mean weight

    % Propagate sigma points through dynamics and observation
    FX = f (X);
    Y  = h (FX);

    % Affine regression from X to Y = h (f(X)) to estimate HF
    yf = sum (repmat (weights, M, 1) .* Y, 2);
    deltaX = X (:,2:end) - repmat (xa, 1, 2 * N);
    deltaY = Y (:,2:end) - repmat (yf, 1, 2 * N);
    HF = (deltaY / deltaX);

    % Forecast state (xf) and forecast covariance (Pxx = FPF + Q)
    xf = sum (repmat (weights, N, 1) .* FX, 2);
    deltaFX = FX (:,2:end) - repmat (xf, 1, 2 * N);
    FPF = (deltaFX * weightMatrix * deltaFX'); % Forecasted process covariance
    Pxx = FPF + Q;

    % Rebuild ensemble around (xf, Pxx) and re-evaluate observation
    [FX, weights] = unscentedEnsemble (xf, Pxx, sqrt (N - 1));
    deltaFX = FX (:,2:end) - repmat (xf, 1, 2 * N);
    Y = h (FX);

    % Predicted observation stats
    yf = sum (repmat (weights, M, 1) .* Y, 2);
    deltaY = Y (:,2:end) - repmat (yf, 1, 2 * N);
    Pb = deltaY * weightMatrix * deltaY'; % Obs covariance before adding R
    Py = Pb + R; % Predicted obs covariance
    Pxy = deltaFX * weightMatrix * deltaY'; % Cross covariance

    % Kalman update
    K = Pxy / Py;
    HT = (Pxx \ Pxy); % Transpose of linearized H * F (via covariance identity)

    innov = (obs - yf);
    xa = xf + K * innov;
    Pa = Pxx - K * Py * K';

    % Instantaneous noise estimates (to be averaged in AUKF)
    if Q_param == 0
        Qest = 0; Rest = 0;
    else
        Gamma0 = innov * innov.'; % E[ν_t ν_t^T]
        Gamma0prev = prev_innov * prev_innov.'; % E[ν_{t-1} ν_{t-1}^T]
        Gamma1 = innov * prev_innov.'; % E[ν_t ν_{t-1}^T]

        Rest = Gamma0 - Pb;

        if Q_param == 1 % Full Q
            Mfull = (HF \ Gamma1 + K * Gamma0prev) / HT;
            Qest  = Mfull - prev_FPF;
        else % Parameterized Q
            C = (Gamma1 + HF * K * Gamma0prev - HF * prev_FPF * HT);
            % Keep the original function name to match your repo
            Qest = Qparamaterization (C(:), HF, HT, Q_param);
        end
    end

warning('on', 'MATLAB:rankDeficientMatrix');
end
