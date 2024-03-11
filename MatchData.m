clc;
clear;
close all;
addpath(genpath(pwd));

% Load the .mat file data
matData = load('CircleAt00500Radius100Duration5.mat');
positionsMAT = matData.recordedPositions;

% Load the .csv file data
csvData = readtable('CircleAt00500Radius100Duration5.csv');
% Extract TX, TY, and TZ columns
tx = csvData.Var6(2:end);
ty = csvData.Var7(2:end);
tz = csvData.Var8(2:end);
csvPositions = [tx, ty, tz]';

% Calculate the mean of the first 100 points in the CSV dataset
meanFirst100CSV = mean(csvPositions(:, 1:100), 2);

% Define the target position
targetPosition = [0; 0; 623];

% Calculate the translation vector
translationVector = targetPosition - meanFirst100CSV;

% Apply translation
csvPositionsTranslated = bsxfun(@plus, csvPositions, translationVector);

% Apply manual rotation
rotationAngleDegrees = 90;
rotationAngleRadians = deg2rad(rotationAngleDegrees);
rotationMatrixZ = [cos(rotationAngleRadians), -sin(rotationAngleRadians), 0;
                   sin(rotationAngleRadians), cos(rotationAngleRadians), 0;
                   0, 0, 1];
csvPositionsRotated = rotationMatrixZ * csvPositionsTranslated;

% Transpose datasets for consistency
positionsMAT = positionsMAT'; % Transpose to Nx3
positionsCSV = csvPositionsRotated'; % Transpose to Nx3

% Perform nearest neighbor search
[idx, distances] = knnsearch(positionsCSV, positionsMAT);

% Find the maximum distance and its corresponding points
[maxDistance, maxIndex] = max(distances);
pointMAT = positionsMAT(maxIndex, :);
nearestPointCSV = positionsCSV(idx(maxIndex), :);

% Plotting
figure;
hold on;

% Plot data points
hMat = plot3(positionsMAT(:, 1), positionsMAT(:, 2), positionsMAT(:, 3), '+', 'DisplayName', 'MAT File Data');
hCsv = plot3(positionsCSV(:, 1), positionsCSV(:, 2), positionsCSV(:, 3), '+', 'DisplayName', 'Aligned and Rotated CSV Data');

% Highlight maximum distance pair
plot3([pointMAT(1), nearestPointCSV(1)], [pointMAT(2), nearestPointCSV(2)], [pointMAT(3), nearestPointCSV(3)], 'k-', 'LineWidth', 2);
plot3(pointMAT(1), pointMAT(2), pointMAT(3), 'go', 'MarkerSize', 10, 'LineWidth', 2);
plot3(nearestPointCSV(1), nearestPointCSV(2), nearestPointCSV(3), 'go', 'MarkerSize', 10, 'LineWidth', 2);

% Annotate maximum distance
midPoint = (pointMAT + nearestPointCSV) / 2;
text(midPoint(1), midPoint(2), midPoint(3) + 20, sprintf('%.1f cm', maxDistance / 10), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold');

% Adjust legend
legend([hMat, hCsv], 'Location', 'best');

xlabel('X');
ylabel('Y');
zlabel('Z');
title('Nearest Neighbors Visualization with Maximum Distance Highlighted');
grid on;
hold off;

% Display distances in cm
disp(['Mean Distance: ', num2str(mean(distances) / 10, '%.1f'), ' cm']);
disp(['Maximum Distance: ', num2str(maxDistance / 10, '%.1f'), ' cm']);

% Clear variables no longer needed
clearvars -except positionsMAT positionsCSV
