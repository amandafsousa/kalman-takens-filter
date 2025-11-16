function ComputeErrorsPlotResults (T, figureName, obs, stateEstimateNoModel)
%ComputeErrorsPlotResults Plot observed data and no model filtered estimates.
% Inputs:
%  T: number of samples to plot;
%  figureName: name for the MATLAB figure window;
%  obs: M-by-T matrix of observed data;
%  stateEstimateNoModel: M-by-T matrix of filtered estimates (no model).
% Description:
%  Creates a visualization comparing original observations with the non model Kalman-Takens filtered output over the first T samples.

    plotInds = 1:T;

    figure ('Name', figureName, 'NumberTitle', 'off');
    plot (obs (1, plotInds), 'k.-'); % Observations
    hold on;

    plot (stateEstimateNoModel (1, plotInds), 'bx-'); % Filtered (no model)

    grid on;
    legend ('Observations', 'No Model Filter', 'Location', 'southeast');

    ylabel ('Packet Size (kbit)', 'FontSize', 12);
    xlabel ('Transmission Time (ms)', 'FontSize', 12);
    title ('Transmission Time Analysis: Observed vs. Filtered');

    % Axis formatting
    ax = gca;
    ax.FontSize = 12;
    ax.Title.FontSize = 12;
    ax.Legend.FontSize = 12;

    hold off;
end
