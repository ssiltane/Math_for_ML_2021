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
gridline_color = [.6 .6 .6];
gridline_width = .5;
msize = 6;
msize2 = 8;
fsize = 26;
fsize2 = 12;
tickfsize = 16;
separ = .2;
lwidth = 1;
lwidth2 = .5;

% Interval between January and July temperatures
a = 6;
b = 8;

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

% First data coordinate is average air pressure. The 30 first components
% are from April, and components 31-60 are from July.
x1 = [w04y19(:,2);w07y19(:,2)];

% Second data coordinate is average temperature. The 30 first components
% are from April, and components 31-60 are from July.
x2 = [w04y19(:,6);w07y19(:,6)];

% In these demonstrations we want to use normalized data where all data 
% values are between zero and one. Load normalization constants used in the
% trained networks in subfolder ML_Higham_applied2weather/
load ML_Higham_applied2weather/Highamdata x1MIN x1MAX x2MIN x2MAX 
x1 = x1-x1MIN;
x1 = x1/(x1MAX-x1MIN);
x2 = x2-x2MIN;
x2 = x2/(x2MAX-x2MIN);


%% Picture 1, April and July normalized temperatures and air pressures in 2019 

figure(1)
clf
p1 = plot(x1(1:30),x2(1:30),'bs','markersize',msize);
hold on
set(p1,'color',color_spring)
set(p1,'markerfacecolor',color_spring)
%
p1 = plot(x1(31:60),x2(31:60),'bd','markersize',msize);
set(p1,'color',color_summer)
set(p1,'markerfacecolor',color_summer)
%
set(gca,'xtick',[0:.1:1],'fontsize',tickfsize)
set(gca,'ytick',[0:.1:1],'fontsize',tickfsize)
axis([0 1 0 1])
axis square


%% Picture 2, rotate the data 45 degrees

% Rotation angle
theta = pi/4;

% Construct rotation matrix
A = [[cos(theta) -sin(theta)];[sin(theta) cos(theta)]];

% Re-arrange the data so that each column of a 2x60 matrix has the
% x1-coordinate of a data point in the first row and x2-coordinate in the
% second row
tmp = [x1(:).';x2(:).'];

% Multiply by rotation matrix. Because of matrix algebra rules, all data
% points get rotated. 
Ax = A*tmp;

% Transpose the result so that again first column is for x1-coordinates and
% second column for x2-coordinates
Ax = Ax.';

% Pick out the coordinates of the rotated data values
Ax1 = Ax(:,1);
Ax2 = Ax(:,2);

% Plot the data
figure(2)
clf
p1 = plot(Ax1(1:30),Ax2(1:30),'bs','markersize',msize);
hold on
set(p1,'color',color_spring)
set(p1,'markerfacecolor',color_spring)
%
p1 = plot(Ax1(31:60),Ax2(31:60),'bd','markersize',msize);
set(p1,'color',color_summer)
set(p1,'markerfacecolor',color_summer)
%
set(gca,'xtick',[-1:.1:1],'fontsize',tickfsize)
set(gca,'ytick',[0:.1:1.2],'fontsize',tickfsize)
axis equal
axis([-.6 .6 0 1.1])





%% Picture 3, apply relu


% Plot the data
figure(3)
clf
p1 = plot(relu(Ax1(1:30)),relu(Ax2(1:30)),'bs','markersize',msize);
hold on
set(p1,'color',color_spring)
set(p1,'markerfacecolor',color_spring)
%
p1 = plot(relu(Ax1(31:60)),relu(Ax2(31:60)),'bd','markersize',msize);
set(p1,'color',color_summer)
set(p1,'markerfacecolor',color_summer)
%
set(gca,'xtick',[-1:.1:1],'fontsize',tickfsize)
set(gca,'ytick',[0:.1:1.2],'fontsize',tickfsize)
axis equal
axis([-.6 .6 0 1.1])





%% Picture 4, project to horizontal axis


% Plot the data
figure(4)
clf
p1 = plot(Ax1(1:30),zeros(1,30),'bs','markersize',msize);
hold on
set(p1,'color',color_spring)
set(p1,'markerfacecolor',color_spring)
%
p1 = plot(Ax1(31:60),zeros(1,30),'bd','markersize',msize);
set(p1,'color',color_summer)
set(p1,'markerfacecolor',color_summer)
%
set(gca,'xtick',[-1:.1:1],'fontsize',tickfsize)
set(gca,'ytick',[-1:.1:1.2],'fontsize',tickfsize)
axis equal
axis([-.6 .6 -.3 .3])





%% Picture 5, project to horizontal axis and apply relu


% Plot the data
figure(5)
clf
p1 = plot(relu(Ax1(1:30)),zeros(1,30),'bs','markersize',msize);
hold on
set(p1,'color',color_spring)
set(p1,'markerfacecolor',color_spring)
%
p1 = plot(relu(Ax1(31:60)),zeros(1,30),'bd','markersize',msize);
set(p1,'color',color_summer)
set(p1,'markerfacecolor',color_summer)
%
set(gca,'xtick',[-1:.1:1],'fontsize',tickfsize)
set(gca,'ytick',[-1:.1:1.2],'fontsize',tickfsize)
axis equal
axis([-.6 .6 -.3 .3])





%% Picture 6, same as picture, but using a neuron

NNresult = zeros(size(x1));
for iii = 1:60
    NNresult(iii) = SingleNeuron(x1(iii),x2(iii));
end

% Plot the data
figure(6)
clf
p1 = plot(NNresult(1:30),zeros(1,30),'bs','markersize',msize);
hold on
set(p1,'color',color_spring)
set(p1,'markerfacecolor',color_spring)
%
p1 = plot(NNresult(31:60),zeros(1,30),'bd','markersize',msize);
set(p1,'color',color_summer)
set(p1,'markerfacecolor',color_summer)
%
set(gca,'xtick',[-1:.1:1],'fontsize',tickfsize)
set(gca,'ytick',[-1:.1:1.2],'fontsize',tickfsize)
axis equal
axis([-.6 .6 -.3 .3])







