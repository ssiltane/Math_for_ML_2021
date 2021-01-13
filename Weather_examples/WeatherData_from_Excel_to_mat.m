% Load weather data from various months of measurements in Kumpula.
% Save the data to files.
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



%% Data from 2015

% Read in data and pre-process it by taking daily averages
w04orig = xlsread('data/201504_KumpulaLong2.xlsx');
w04orig = w04orig(1:end-1,:);
[row,col] = size(w04orig);
w04 = zeros(row/24,col);
for iii = 1:row/24
   w04(iii,:) = mean(w04orig((iii-1)*24+[1:24],:)); 
end
%
w07orig = xlsread('data/201507_KumpulaLong2.xlsx');
w07orig = w07orig(1:end-1,:);
[row,col] = size(w07orig);
% Replace one missing measurement by average of neighbor measurements
w07orig(683,6) = (w07orig(682,6)+w07orig(684,6))/2;
w07 = zeros(row/24,col);
for iii = 1:row/24
   w07(iii,:) = mean(w07orig((iii-1)*24+[1:24],:)); 
end

% Save to file
save data/weather2015 w04 w07




%% Data from 2016

% Read in data and pre-process it by taking daily averages
w01orig = xlsread('data/201601_KumpulaLong2.xlsx');
w01orig = w01orig(1:end-1,:);
[row,col] = size(w01orig);
w01 = zeros(row/24,col);
for iii = 1:row/24
   w01(iii,:) = mean(w01orig((iii-1)*24+[1:24],:)); 
end
%
w04orig = xlsread('data/201604_KumpulaLong2.xlsx');
w04orig = w04orig(1:end-1,:);
[row,col] = size(w04orig);
w04 = zeros(row/24,col);
for iii = 1:row/24
   w04(iii,:) = mean(w04orig((iii-1)*24+[1:24],:)); 
end
%
w07orig = xlsread('data/201607_KumpulaLong2.xlsx');
w07orig = w07orig(1:end-1,:);
[row,col] = size(w07orig);
% Replace one missing measurement by average of neighbor measurements
w07orig(683,6) = (w07orig(682,6)+w07orig(684,6))/2;
w07 = zeros(row/24,col);
for iii = 1:row/24
   w07(iii,:) = mean(w07orig((iii-1)*24+[1:24],:)); 
end
%
w10orig = xlsread('data/201610_KumpulaLong2.xlsx');
w10orig = w10orig(1:end-1,:);
[row,col] = size(w10orig);
w10 = zeros(row/24,col);
for iii = 1:row/24
   w10(iii,:) = mean(w10orig((iii-1)*24+[1:24],:)); 
end

% Save to file
save data/weather2016 w01 w04 w07 w10


%% Data from 2017


% Read in data and pre-process it by taking daily averages
w01orig = xlsread('data/201701_KumpulaLong2.xlsx');
w01orig = w01orig(1:end-1,:);
[row,col] = size(w01orig);
w01 = zeros(row/24,col);
for iii = 1:row/24
   w01(iii,:) = mean(w01orig((iii-1)*24+[1:24],:)); 
end
%
w04orig = xlsread('data/201704_KumpulaLong2.xlsx');
w04orig = w04orig(1:end-1,:);
[row,col] = size(w04orig);
w04 = zeros(row/24,col);
for iii = 1:row/24
   w04(iii,:) = mean(w04orig((iii-1)*24+[1:24],:)); 
end
%
w07orig = xlsread('data/201707_KumpulaLong2.xlsx');
w07orig = w07orig(1:end-1,:);
[row,col] = size(w07orig);
% Replace one missing measurement by average of neighbor measurements
w07orig(683,6) = (w07orig(682,6)+w07orig(684,6))/2;
w07 = zeros(row/24,col);
for iii = 1:row/24
   w07(iii,:) = mean(w07orig((iii-1)*24+[1:24],:)); 
end
%
w10orig = xlsread('data/201710_KumpulaLong2.xlsx');
w10orig = w10orig(1:end-1,:);
[row,col] = size(w10orig);
w10 = zeros(row/24,col);
for iii = 1:row/24
   w10(iii,:) = mean(w10orig((iii-1)*24+[1:24],:)); 
end

% Save to file
save data/weather2017 w01 w04 w07 w10


%% Data from 2019

% Read in data and pre-process it by taking daily averages
w01orig = xlsread('data/201901_KumpulaLong2.xlsx');
w01orig = w01orig(1:end-1,:);
[row,col] = size(w01orig);
w01 = zeros(row/24,col);
for iii = 1:row/24
   w01(iii,:) = mean(w01orig((iii-1)*24+[1:24],:)); 
end
%
w04orig = xlsread('data/201904_KumpulaLong2.xlsx');
w04orig = w04orig(1:end-1,:);
[row,col] = size(w04orig);
w04 = zeros(row/24,col);
for iii = 1:row/24
   w04(iii,:) = mean(w04orig((iii-1)*24+[1:24],:)); 
end
%
w07orig = xlsread('data/201907_KumpulaLong2.xlsx');
w07orig = w07orig(1:end-1,:);
[row,col] = size(w07orig);
% Replace one missing measurement by average of neighbor measurements
w07orig(683,6) = (w07orig(682,6)+w07orig(684,6))/2;
w07 = zeros(row/24,col);
for iii = 1:row/24
   w07(iii,:) = mean(w07orig((iii-1)*24+[1:24],:)); 
end
%
w10orig = xlsread('data/201910_KumpulaLong2.xlsx');
w10orig = w10orig(1:end-1,:);
[row,col] = size(w10orig);
w10 = zeros(row/24,col);
for iii = 1:row/24
   w10(iii,:) = mean(w10orig((iii-1)*24+[1:24],:)); 
end

% Save to file
save data/weather2019 w01 w04 w07 w10


