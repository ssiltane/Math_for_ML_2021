% Classify weather data from various months measured in Kumpula. 
%
% Samuli Siltanen February 2021
% Modified by Siiri Rautio 2024

clear all
close all

% Graphical parameters
color_summer = [200 0 0]/255;
color_fall   = [255 124 45]/255;
color_winter = [0 0 255]/255;
color_spring = [20 200 185]/255;
msize        = 6;

% Load weather data
% Column 2: Pressure (msl)	hPa
% Column 6: Air temperature	degC
load data/weather2019 w04 w07

w04y19 = w04; % April
w07y19 = w07; % July

% First data coordinate is average air pressure (column 2). The 30 first 
% datapoints are from April, and datapoints 31-60 are from July.
x1 = [w04y19(:,2); w07y19(:,2)];
x1(59) = mean([x1(58),x1(60)]); % Remove one not-a-number (NaN) value from the data

% Second data coordinate is average temperature (column 6). The 30 first 
% datapoints are from April, and datapoints 31-60 are from July.
x2 = [w04y19(:,6); w07y19(:,6)];

% In these demonstrations we want to use normalized data where all data 
% values are between zero and one. Load normalization constants used in the
% trained networks in subfolder ML_Higham_applied2weather/
load ML_Higham_applied2weather/Highamdata x1MIN x1MAX x2MIN x2MAX 

x1 = x1-x1MIN;
x1 = x1/(x1MAX-x1MIN);
x2 = x2-x2MIN;
x2 = x2/(x2MAX-x2MIN);

%% Demo 1, April and July normalized temperatures and air pressures in 2019 

% The conclusion is that the data is almost completely classified by a
% diagonal line connecting the origin and the point (1,1). Namely, the July
% days are above that diagonal line and all but one April days are below
% the line. 

% Plot the data
figure(1)
clf

% Plot the spring data points
plot(x1(1:30),x2(1:30),'bs','color',color_spring, 'markerfacecolor',color_spring)
hold on

% Plot the summer data points
plot(x1(31:60),x2(31:60),'bs','color',color_summer, 'markerfacecolor',color_summer)
axis([0,1,0,1])
axis square
title('Normalized data points')
xlabel('air pressure')
ylabel('temperature')


%% Demo 2, rotate the data 45 degrees

% In this demo number 2 we rotate the data points using a rotation matrix.
% After rotation the data is almost completely classified by the vertical
% coordinate axis. Namely, the July days all have a negative horizontal 
% coordinate and all but one April days have a positive horizontal 
% coordinate. 

% Rotation angle is 45 degrees counter-clockwise
theta = pi/4;

% Construct rotation matrix
A = [[cos(theta), -sin(theta)];[sin(theta), cos(theta)]];

% Re-arrange the data so that each column of a 2x60 matrix has the
% x1-coordinate of a data point in the first row and x2-coordinate in the
% second row. (The notation (:) drops any vector or matrix into a vertical
% vector.)
tmp = [x1(:).'; x2(:).'];

% Multiply by rotation matrix. Because of matrix algebra rules, all data
% points get rotated since they are organized as columns. 
Ax = A*tmp;

% Transpose the result so that again first column is for x1-coordinates and
% second column for x2-coordinates
Ax = Ax.';

% Pick out the coordinates of the rotated data values
air_pressures = Ax(:,1);
temperatures  = Ax(:,2);

% Plot the data
figure(2)
clf
% Plot the spring data points
plot(air_pressures(1:30),temperatures(1:30),'bs','color',color_spring, 'markerfacecolor',color_spring)
hold on

% Plot the summer data points
plot(air_pressures(31:60),temperatures(31:60),'bs','color',color_summer, 'markerfacecolor',color_summer)
axis([-0.5,0.5,0,1])
axis square
title('Rotated data points')
xlabel('air pressure')
ylabel('temperature')


%% Demo 3, apply relu to all the coordinates of the rotated data

% The result of applying relu is that all July points (and one April point)
% are located on the vertical axis. This is because all negative horizontal
% coordinates were replaced by zero. 

% Apply ReLU
relu_airp = relu(air_pressures);
relu_temp = relu(temperatures);


% Plot the data
figure(3)
clf
% Plot the spring data points
plot(relu_airp(1:30),relu_temp(1:30),'bs','color',color_spring, 'markerfacecolor',color_spring)
hold on

% Plot the summer data points
plot(relu_airp(31:60),relu_temp(31:60),'bs','color',color_summer, 'markerfacecolor',color_summer)
axis([-0.5,0.5,0,1])
axis square
title('Relu of rotated')
xlabel('air pressure')
ylabel('temperature')

%% Demo 4, project to horizontal axis

% Since the data is classified by the horizontal coordinate, we might as
% well apply "dimension reduction" simply by replacing the vertical
% coordinates by zeros. After all, they are not relevant for the
% classification. Now all the data points are scattered on the horizontal
% axis, with July days (and one April day) located on the negative
% half-line. 

% Plot the data
figure(4)
clf
% Plot the spring data points
plot(relu_airp(1:30),zeros(1,30),'bs','color',color_spring, 'markerfacecolor',color_spring)
hold on

% Plot the summer data points
plot(relu_airp(31:60),zeros(1,30),'bs','color',color_summer, 'markerfacecolor',color_summer)
%axis([-0.5,0.5,0,1])
axis square
title('Projected')
xlabel('air pressure')
ylabel('temperature')


%% Demo 5, project to horizontal axis and apply relu

% We can build on demo 4 by applying relu to the coordinates. Then we can 
% use the following classification rule: "if a rotated and relu-mapped data
% point has horizontal coordinate zero, then it is a July day." 
% This rule classifies all July days in our data set correctly
% (and one of the April days incorrectly). 

% Plot the data

figure(4)
clf
% Plot the spring data points
plot(relu_airp(1:30),zeros(1,30),'bs','color',color_spring, 'markerfacecolor',color_spring)
hold on

% Plot the summer data points
plot(relu_airp(31:60),zeros(1,30),'bs','color',color_summer, 'markerfacecolor',color_summer)
%axis([-0.5,0.5,0,1])
axis square
title('Projected')
xlabel('air pressure')
ylabel('temperature')


%% Demo 6. Exactly the same process as in demo 5, but using a neuron

% We encode the classification rule of Demo 5 into a single computational
% neuron implemented in routine SingleNeuron.m.
NNresult = zeros(size(x1));

for iii = 1:60
    NNresult(iii) = singleNeuron(x1(iii),x2(iii));
end

% Plot the data
figure(5)
clf
% Plot the spring data points
plot(NNresult(1:30),zeros(1,30),'bs','color',color_spring, 'markerfacecolor',color_spring)
hold on

% Plot the summer data points
plot(NNresult(31:60),zeros(1,30),'bs','color',color_summer, 'markerfacecolor',color_summer)
%axis([-0.5,0.5,0,1])
axis square
title('Neuron')
xlabel('air pressure')
ylabel('temperature')















































