clc; clear; close all;

addpath('KalmanTakens');
addpath('AdaptiveUKF');
addpath('Util');

% LOADING TEST DATA:
% KTFcore (FILE, COLUMN, filterRowsFrom, filterRowsTo, plotTitle, filterTransient, delays, kNN, N).
% FILE: path of timetable (CSV/TT);
% COLUMN: table column to be analyzed;
% filterRowsFrom: first row to include (if > 0);
% filterRowsTo: last row to include  (if > 0);
% plotTitle: base plot title;
% filterTransient: discard first N samples when computing errors;
% delays: Takens embedding dimension;
% kNN: number of nearest neighbors;
% N: number of state variables.

% AfreecaTV
plotTitle = "";
FILE = fullfile('..', 'data', 'Serie_AfreecaTV_2_tt_rt_five_sec_without_nan.csv');
COLUMN = "Length";
filterTransient = 1000;
delays = 2;
kNN = 1;
N = 1;
filterRowFrom = 1;
filterRowTo = 1000;
KTFcore (FILE, COLUMN, filterRowFrom, filterRowTo, plotTitle, filterTransient, delays, kNN, N);

% MS Teams
%plotTitle = "";
%FILE = fullfile('..', 'data', 'Serie_MSTeams_1_tt_five_dec_sec.csv');
%COLUMN = "Length";
%filterTransient = 1000;
%delays = 2;
%kNN = 10;
%N = 1;
%filterRowFrom = 1;
%filterRowTo = 1000;
%KTFcore (FILE, COLUMN, filterRowFrom, filterRowTo, plotTitle, filterTransient, delays, kNN, N);

% YouTube
%plotTitle = "";
%FILE = fullfile('..', 'data', 'Serie_YouTube_1_tt_ten_sec_without_nan.csv');
%COLUMN = "Length";
%filterTransient = 1000;
%delays = 2;
%kNN = 1;
%N = 1;
%filterRowFrom = 1;
%filterRowTo = 1000;
%KTFcore (FILE, COLUMN, filterRowFrom, filterRowTo, plotTitle, filterTransient, delays, kNN, N);

xlabel ('Transmission Time (ms)');
ylabel ('Packet Size (kbit)');

legend ('Observations', 'No-Model Filter');
