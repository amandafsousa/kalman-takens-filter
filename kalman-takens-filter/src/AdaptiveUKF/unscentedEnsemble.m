function [x, w] = unscentedEnsemble (mu, C, scale)
%unscentedEnsemble Build an unscented sigma point ensemble.
% Inputs:
%  mu: n-by-1 state mean vector;
%  C: n-by-n state covariance matrix;
%  scale (optional): scaling parameter, typically alpha*sqrt(n+kappa), default: sqrt(n+1).
% Outputs:
%  x: n-by-(2n+1) matrix of sigma points;
%  w: 1-by-(2n+1) vector of sigma point weights.
% Notes:
%  The ensemble is constructed such that its empirical mean and covariance match (mu, C), given the chosen scaling parameter.

    n = length (mu);
    if (nargin < 3), scale = sqrt (n + 1); end

    [U, S, ~] = svd (C);

    % Matrix square root of C
    U = U * diag (sqrt (diag (S))) * U';

    % Form the scaled unscented ensemble
    x = zeros (n, 2 * n + 1);
    x (:,1) = mu;
    x (:,2:n + 1) = repmat (mu, 1, n) + scale * U;
    x (:,n + 2:2 * n + 1) = repmat (mu, 1, n) - scale * U;

    % Scaled ensemble weights
    w = [scale ^ 2 - n, ones(1, 2 * n) / 2] / scale ^ 2;
end
