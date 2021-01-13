% Prepare weather data in a form suitable for Higham & Higham NN example. 
% The routine WeatherData_save2mat.m in the parent directory needs to be 
% computed first. 
%
% Column 1: Cloud amount	1/8
% Column 2: Pressure (msl)	hPa
% Column 3: Relative humidity	%
% Column 4: Precipitation intensity	mm/h
% Column 5: Snow depth	cm
% Column 6: Air temperature	degC
% Column 7: Dew-point temperature	degCw
% Column 8: Horizontal visibility	m
% Column 9: Wind direction	deg
% Column 10: Gust speed	m/s
% Column 11: Wind speed	m/s
%
% Samuli Siltanen Oct 2020

% Number of  data pairs
Nweather = 240; % Four months, 30 days each
x2 = zeros(1,Nweather);
x1 = zeros(1,Nweather);
y  = zeros(2,Nweather);

% Form training data set containing April and July temperature and air
% pressure data from years 2017 and 2019
load ../data/weather2017 w01 w04 w07 w10
x2(1:30) = w04(1:30,6); % Temperature
x1(1:30) = w04(1:30,2); % Pressure
y(:,1:30)  = repmat([1;0],1,30); % April
load ../data/weather2019 w01 w04 w07 w10
x2(31:60) = w04(1:30,6); % Temperature
x1(31:60) = w04(1:30,2); % Pressure
y(:,31:60)  = repmat([1;0],1,30); % April
load ../data/weather2017 w01 w04 w07 w10
x2(61:90) = w07(1:30,6); % Temperature
x1(61:90) = w07(1:30,2); % Pressure
y(:,61:90)  = repmat([0;1],1,30); % July
load ../data/weather2019 w01 w04 w07 w10
x2(91:120) = w07(1:30,6); % Temperature
x1(91:120) = w07(1:30,2); % Pressure
y(:,91:120)  = repmat([0;1],1,30); % July
load ../data/weather2016 w01 w04 w07 w10
x2(121:150) = w04(1:30,6); % Temperature
x1(121:150) = w04(1:30,2); % Pressure
y(:,121:150)  = repmat([1;0],1,30); % April
load ../data/weather2016 w01 w04 w07 w10
x2(151:180) = w07(1:30,6); % Temperature
x1(151:180) = w07(1:30,2); % Pressure
y(:,151:180)  = repmat([0;1],1,30); % July
load ../data/weather2015 w01 w04 w07 w10
x2(181:210) = w04(1:30,6); % Temperature
x1(181:210) = w04(1:30,2); % Pressure
y(:,181:210)  = repmat([1;0],1,30); % April
load ../data/weather2015 w01 w04 w07 w10
x2(211:240) = w07(1:30,6); % Temperature
x1(211:240) = w07(1:30,2); % Pressure
y(:,211:240)  = repmat([0;1],1,30); % July

% Remove NaN value
ind1 = find(isnan(x2));
for iii = 1:length(ind1)
    x2(ind1(iii)) = (x2(ind1(iii)-1)+x2(ind1(iii)+1))/2;
end
ind2 = find(isnan(x1));
for iii = 1:length(ind2)
    x1(ind2(iii)) = (x1(ind2(iii)-1)+x1(ind2(iii)+1))/2;
end


% Transform data to the interval [0,1]
x2MIN = -5;
x2MAX = 30;
x1MIN = 990;
x1MAX = 1040;
x2 = x2-x2MIN;
x2 = x2/(x2MAX-x2MIN);
x1 = x1-x1MIN;
x1 = x1/(x1MAX-x1MIN);



% Save to file
save Highamdata x2 x1 y x2MIN x2MAX x1MIN x1MAX Nweather

figure(100)
clf
a1 = subplot(1,1,1);
for iii = 1:Nweather
    if y(1,iii)>0
        plot(x1(iii),x2(iii),'ro','MarkerSize',12,'LineWidth',4)
        hold on
    else
        plot(x1(iii),x2(iii),'bx','MarkerSize',12,'LineWidth',4)
    end
end
a1.XTick = [0 1];
a1.YTick = [0 1];
a1.FontWeight = 'Bold';
a1.FontSize = 16;
xlim([0,1])
ylim([0,1])

