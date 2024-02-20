% Load the .mat file data
matData = load('yourDataFile.mat'); % Adjust 'yourDataFile.mat' to your actual .mat file name
% Assuming the variable in .mat is named 'positions', and it's a 3x1027 double
positions = matData.positions; % Adjust variable name as necessary

% Load the .csv file data
csvData = readtable('yourCsvFile.csv'); % Adjust 'yourCsvFile.csv' to your actual CSV file name
% Extract TX, TY, and TZ columns
tx = csvData.TX;
ty = csvData.TY;
tz = csvData.TZ;

% Combine into a single matrix (transpose if necessary to match dimensions)
csvPositions = [tx, ty, tz]';

% Define the rotation angle around the Z-axis in degrees
rotationAngleDegrees = 0; % Replace yourAngle with your specific angle
rotationAngleRadians = deg2rad(rotationAngleDegrees);

% Calculate the rotation matrix for Z-axis rotation
rotationMatrixZ = [cos(rotationAngleRadians), -sin(rotationAngleRadians), 0;
                   sin(rotationAngleRadians), cos(rotationAngleRadians), 0;
                   0, 0, 1];

% Apply rotation
csvPositionsRotated = rotationMatrixZ * csvPositions;

% Plotting
figure;
hold on;
plot3(positions(1, :), positions(2, :), positions(3, :), 'ro', 'DisplayName', 'MAT File Data');
plot3(csvPositionsRotated(1, :), csvPositionsRotated(2, :), csvPositionsRotated(3, :), 'b+', 'DisplayName', 'CSV File Data');
legend;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Comparison of Motion Capture Data');
hold off;