function forecast = NonParametricDynamics (state, trainingData, kNN, linearModel, useWeights, forecastHorizon)
%NonParametricDynamics Local nonparametric dynamics model for time series prediction.
% Inputs:
%  state: N-by-E matrix of E state vectors in R^N to forecast;
%  trainingData: N-by-T matrix of T state vectors in R^N used as reference data;
%  kNN: number of nearest neighbors for the forecast (default = 40);
%  linearModel: 1 = use locally linear model, 0 = use local average (default = 0);
%  useWeights: 1 = weight neighbors based on distance, 0 = equal weights (default = 1);
%  forecastHorizon: number of steps to forecast (use 1 for filtering; default = 1).
% Output:
%  forecast: N-by-E matrix containing one step (or multi step) forecasts.
% Description:
%  For each input state vector, this function searches for the kNN nearest neighbors in the trainingData matrix (excluding the last forecastHorizon samples so that targets exist ahead in time);
%  If linearModel = 1, a locally linear mapping between the neighbors and their future targets is estimated. Otherwise, the function returns a weighted average of the neighbor targets.
% See also: pdist2, TakensEmbedding, NonParametricObs.

    if (nargin < 6), forecastHorizon = 1; end
    if (nargin < 5), useWeights = 1; end
    if (nargin < 4), linearModel = 0; end
    if (nargin < 3), kNN = 40; end
    
    % Find the k nearest neighbors for each state vector
    [ds, inds] = pdist2 (trainingData (:,1:end-forecastHorizon)', state', 'euclidean', 'smallest', kNN);

    % Compute distance based or uniform weights
    if useWeights
        sigma = (1/2) * mean (ds);
        weights = exp (- (ds ./ repmat (sigma, size (ds, 1), 1)));
        weights = weights ./ repmat (sum (weights, 1), size (weights, 1), 1);
    else
        weights = ones (kNN, size (inds, 2)) / kNN;
    end

    forecast = zeros (size (state));

    if linearModel
        % Locally linear model
        for i = 1:size (inds, 2)
            Fnn = trainingData (:, inds (:, i) + forecastHorizon); % Target points
            muFnn = Fnn * weights (:, i); % Target mean
            nn = trainingData (:, inds (:, i)); % Source points
            munn = nn * weights (:, i); % Source mean

            % Local linear mapping (affine model)
            llModel = (Fnn - repmat (muFnn, 1, size (Fnn, 2))) / (nn - repmat (munn, 1, size(nn, 2)));

            forecast (:, i) = llModel * (state (:, i) - munn) + muFnn;
        end
    else
        % Weighted average of neighbor targets
        for i = 1:size (inds, 2)
            forecast (:, i) = trainingData (:, inds (:, i) + forecastHorizon) * weights(:, i);
        end
    end
end
