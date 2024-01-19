% Classify weather data from various months measured in Kumpula.
%
% Column 1: Cloud amount	1/8
% Column 2: Pressure (msl)	hPa
% Column 3: Relative humidity	%
% Column 4: Precipitation intensity	mm/h
% Column 5: Snow depth	cm
% Column 6: Air temperature	degC
% Column 7: Dew-point temperature	degC
% Column 8: Horizontal visibility	m
% Column 9: Wind direction	deg
% Column 10: Gust speed	m/s
% Column 11: Wind speed	m/s
%
% Samuli Siltanen 2021
% Modified by Siiri Rautio 2024

clear all
close all

% Graphical parameters
color_summer = [200 0 0]/255;
color_fall   = [255 124 45]/255;
color_winter = [0 0 255]/255;
color_spring = [20 200 185]/255;
msize = 6;

% Load precomputed neural net weights and biases.
load data/NN_parameters W2 b2 W3 b3 W4 b4

%% Picture 1, April and July normalized temperatures and air pressures in 
% 2015 - 2019

% Load normalized data
load ML_Higham_applied2weather/Highamdata x1 x2 y
len = length(x1);

% Plot data
figure(1)
clf
for iii = 1:len
    if y(1,iii)>0 % spring
        plot(x1(iii),x2(iii),'bs','markersize',msize,'color',color_spring,'markerfacecolor',color_spring);
    else % summer
        plot(x1(iii),x2(iii),'bs','markersize',msize,'color',color_summer,'markerfacecolor',color_summer);
    end   
    hold on
end
xlabel('air pressure')
ylabel('temperature')
axis([0 1 0 1])
axis square
title('Normalized data points (2019)')

%% Picture 2, apply weight matrix and bias of first hidden layer

% Re-arrange the data so that each column of a 2x60 matrix has the
% x1-coordinate of a data point in the first row and x2-coordinate in the
% second row
tmp = [x1(:).';x2(:).'];

% Multiply by weight matrix.
W2x = W2*tmp;

% Transpose the result so that again first column is for x1-coordinates and
% second column for x2-coordinates
W2x = W2x.';

% Pick out the coordinates of the rotated data values
W2x1 = W2x(:,1); %spring
W2x2 = W2x(:,2); %summer

% Add bias
W2x1b = W2x1+b2(1);
W2x2b = W2x2+b2(2);

% Plot the data
figure(2)
clf
for iii = 1:len
    if y(1,iii)>0   % spring
        plot(W2x1b(iii),W2x2b(iii),'bs','markersize',msize,'color',color_spring,'markerfacecolor',color_spring);
    else            % summer
        plot(W2x1b(iii),W2x2b(iii),'bs','markersize',msize,'color',color_summer,'markerfacecolor',color_summer);
    end
    hold on
end
axis equal
title('Data points in hidden layer 1, without activation')


%% Picture 3, apply activation function
output_hlayer1a = sigmoid(W2x1b);
output_hlayer1b = sigmoid(W2x2b);

% Plot the data
figure(3)
clf
for iii = 1:len
    if y(1,iii)>0
    plot(output_hlayer1a(iii),output_hlayer1b(iii),'bs','markersize',msize,'color',color_spring,'markerfacecolor',color_spring);
    else
        plot(output_hlayer1a(iii),output_hlayer1b(iii),'bs','markersize',msize,'color',color_summer,'markerfacecolor',color_summer);
    end
    hold on
end
axis equal
title('Data points in layer 2, with activation')



