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
% Samuli Siltanen January 2021

% Graphical parameters
color_summer = [200 0 0]/255;
color_summer_light = [245 226 226]/255;
color_fall   = [255 124 45]/255;
color_winter = [0 0 255]/255;
color_spring = [20 200 185]/255;
color_spring_light = [217 255 235]/255;
color_line = [.5 .5 .5];
gridline_color = [.7 .7 .7];
gridline_width = .5;
msize = 6;
msize2 = 8;
fsize = 26;
fsize2 = 12;
tickfsize = 16;
separ = .2;
lwidth = 1;
lwidth2 = .5;

load data/weather2015 w04 w07
w04y15 = w04;
w07y15 = w07;

load data/weather2016 w01 w04 w07 w10
w01y16 = w01;
w04y16 = w04;
w07y16 = w07;
w10y16 = w10;

load data/weather2017 w01 w04 w07 w10
w01y17 = w01;
w04y17 = w04;
w07y17 = w07;
w10y17 = w10;

load data/weather2019 w01 w04 w07 w10
w01y19 = w01;
w04y19 = w04;
w07y19 = w07;
w10y19 = w10;

% Load precomputed neural net weights and biases.
load data/NN_parameters W2 b2 W3 b3 W4 b4

% Load normalized data
load ML_Higham_applied2weather/Highamdata x1 x2 y
len = length(x1);

%% Picture 1, April and July normalized temperatures and air pressures in 2019

figure(1)
clf
for iii = 1:len
    p1 = plot(x1(iii),x2(iii),'bs','markersize',msize);
    hold on
    if y(1,iii)>0
        set(p1,'color',color_spring)
        set(p1,'markerfacecolor',color_spring)
    else
        set(p1,'color',color_summer)
        set(p1,'markerfacecolor',color_summer)
    end   
end
%
set(gca,'xtick',[0:.1:1],'fontsize',tickfsize)
set(gca,'ytick',[0:.1:1],'fontsize',tickfsize)
axis([0 1 0 1])
axis square


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
W2x1 = W2x(:,1);
W2x2 = W2x(:,2);

% Add bias
W2x1b = W2x1+b2(1);
W2x2b = W2x2+b2(2);

% Plot the data
figure(2)
clf
for iii = 1:len
    p1 = plot(W2x1b(iii),W2x2b(iii),'bs','markersize',msize);
    hold on
    if y(1,iii)>0
        set(p1,'color',color_spring)
        set(p1,'markerfacecolor',color_spring)
    else
        set(p1,'color',color_summer)
        set(p1,'markerfacecolor',color_summer)
    end

end
axis equal


%% Picture 3, apply activation function


% Plot the data
figure(3)
clf
for iii = 1:len
    p1 = plot(activate(W2x1b(iii),1,0),activate(W2x2b(iii),1,0),'bs','markersize',msize);
    hold on
    if y(1,iii)>0
        set(p1,'color',color_spring)
        set(p1,'markerfacecolor',color_spring)
    else
        set(p1,'color',color_summer)
        set(p1,'markerfacecolor',color_summer)
    end

end
axis equal



