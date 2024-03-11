clc;
clear;
addpath(genpath(pwd));

% Load the .mat file data
matData = load('CircleAt00500Radius100Duration5.mat'); % Adjust 'yourDataFile.mat' to your actual .mat file name
% Assuming the variable in .mat is named 'positions', and it's a 3x1027 double
positions = matData.recordedPositions; % Adjust variable name as necessary

% Load the .csv file data
csvData = readtable('CircleAt00500Radius100Duration5.csv'); % Adjust 'yourCsvFile.csv' to your actual CSV file name
% Extract TX, TY, and TZ columns
tx = csvData.Var6(2:end);
ty = csvData.Var7(2:end);
tz = csvData.Var8(2:end);

% Combine into a single matrix (transpose if necessary to match dimensions)
csvPositions = [tx, ty, tz]';

% Calculate the highest point in both datasets
highestPointMAT = max(positions, [], 2);
highestPointCSV = max(csvPositions, [], 2);

% Calculate the translation vector needed to match these highest points
translationVector = highestPointMAT - highestPointCSV;

% Apply translation
csvPositionsTranslated = csvPositions + repmat(translationVector, 1, size(csvPositions, 2));

% Define the rotation angle around the Z-axis in degrees
rotationAngleDegrees = 90; % Adjust to your specific angle
rotationAngleRadians = deg2rad(rotationAngleDegrees);

% Calculate the rotation matrix for Z-axis rotation
rotationMatrixZ = [cos(rotationAngleRadians), -sin(rotationAngleRadians), 0;
                   sin(rotationAngleRadians), cos(rotationAngleRadians), 0;
                   0, 0, 1];

% Apply rotation
csvPositionsRotated = rotationMatrixZ * csvPositionsTranslated;

% Define the manual offset vector (adjust these values as needed)
offset = [0; 20; 0]; % Example offset values in X, Y, Z

% Apply the manual offset to the rotated CSV data
csvPositionsFinal = csvPositionsRotated + repmat(offset, 1, size(csvPositionsRotated, 2));

% Plotting
figure;
hold on;
plot3(positions(1, :), positions(2, :), positions(3, :), 'ro', 'DisplayName', 'MAT File Data');
plot3(csvPositionsFinal(1, :), csvPositionsFinal(2, :), csvPositionsFinal(3, :), 'b+', 'DisplayName', 'CSV File Data');
legend;
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal
title('Comparison of Motion Capture Data');
hold off;
