clc;
clear;
addpath(genpath(pwd));

% Load the .mat file data
matData = load('CircleAt00500Radius100Duration5.mat'); 
positionsMAT = matData.recordedPositions; 

% Load the .csv file data
csvData = readtable('CircleAt00500Radius100Duration5.csv'); 
tx = csvData.Var6(2:end);
ty = csvData.Var7(2:end);
tz = csvData.Var8(2:end);
csvPositions = [tx, ty, tz]';

% Convert position data to point clouds (assuming you have the Computer Vision Toolbox)
ptCloudMAT = pointCloud(positionsMAT');
ptCloudCSV = pointCloud(csvPositions');

% Align the CSV data to the MAT data using the ICP algorithm
[tform, ptCloudAligned] = pcregistericp(ptCloudCSV, ptCloudMAT, 'Extrapolate', true);

% Extract the aligned positions
alignedPositions = ptCloudAligned.Location';

clearvars -except positionsMAT alignedPositions

% Continue the script from here.
% The alignedPositions are 3x16404 and the positions mat is 3x1025. 