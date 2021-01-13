% Prepare weather data in a form suitable for Higham & Higham NN example. 
% The routine WeatherData_save2mat.m in the parent directory needs to be 
% computed first. 
%
% Column 2: Pressure (msl)	hPa
% Column 3: Relative humidity	%
% Column 6: Air temperature	degC
%
% Samuli Siltanen January 2021

% Number of  data pairs
Nweather = 270; 
x1 = zeros(1,Nweather);
x2 = zeros(1,Nweather);
x3 = zeros(1,Nweather);
y  = zeros(3,Nweather);

% Form training data set containing April and July temperature, air
% pressure and humidity data from years 2016, 2017 and 2019

% Data from year 2016
load ../data/weather2016 w01 w04 w07 w10
x3(1:30) = w01(1:30,6); % Temperature
x2(1:30) = w01(1:30,3); % Humidity
x1(1:30) = w01(1:30,2); % Pressure
y(:,1:30)  = repmat([1;0;0],1,30); % January
x3(31:60) = w04(1:30,6); % Temperature
x2(31:60) = w04(1:30,3); % Humidity
x1(31:60) = w04(1:30,2); % Pressure
y(:,31:60)  = repmat([0;1;0],1,30); % April
x3(61:90) = w07(1:30,6); % Temperature
x2(61:90) = w07(1:30,3); % Humidity
x1(61:90) = w07(1:30,2); % Pressure
y(:,61:90)  = repmat([0;0;1],1,30); % July

% Data from year 2017
load ../data/weather2017 w01 w04 w07 w10
x3(91:120) = w01(1:30,6); % Temperature
x2(91:120) = w01(1:30,3); % Humidity
x1(91:120) = w01(1:30,2); % Pressure
y(:,91:120)  = repmat([1;0;0],1,30); % January
x3(121:150) = w04(1:30,6); % Temperature
x2(121:150) = w04(1:30,3); % Humidity
x1(121:150) = w04(1:30,2); % Pressure
y(:,121:150)  = repmat([0;1;0],1,30); % April
x3(151:180) = w07(1:30,6); % Temperature
x2(151:180) = w07(1:30,3); % Humidity
x1(151:180) = w07(1:30,2); % Pressure
y(:,151:180)  = repmat([0;0;1],1,30); % July


% Data from year 2019
load ../data/weather2019 w01 w04 w07 w10
x3(181:210) = w01(1:30,6); % Temperature
x2(181:210) = w01(1:30,3); % Humidity
x1(181:210) = w01(1:30,2); % Pressure
y(:,181:210)  = repmat([1;0;0],1,30); % January
x3(211:240) = w04(1:30,6); % Temperature
x2(211:240) = w04(1:30,3); % Humidity
x1(211:240) = w04(1:30,2); % Pressure
y(:,211:240)  = repmat([0;1;0],1,30); % April
x3(241:270) = w07(1:30,6); % Temperature
x2(241:270) = w07(1:30,3); % Humidity
x1(241:270) = w07(1:30,2); % Pressure
y(:,241:270)  = repmat([0;0;1],1,30); % July




% Remove NaN value
ind1 = find(isnan(x1));
for iii = 1:length(ind1)
    x1(ind1(iii)) = (x1(ind1(iii)-1)+x1(ind1(iii)+1))/2;
    if isnan(x1(ind1(iii)))
        disp('Nannaa')
    end
end
if length(ind1)>0
    disp([num2str(length(ind1)),' NaN values in x1 removed'])
end
ind2 = find(isnan(x2));
for iii = 1:length(ind2)
    x2(ind2(iii)) = (x2(ind2(iii)-1)+x2(ind2(iii)+1))/2;
    if isnan(x2(ind2(iii)))
        disp('Nannaa')
    end
end
if length(ind2)>0
    disp([num2str(length(ind2)),' NaN values in x2 removed'])
end
ind3 = find(isnan(x3));
for iii = 1:length(ind3)
    x3(ind3(iii)) = (x3(ind3(iii)-1)+x3(ind3(iii)+1))/2;
    if isnan(x3(ind3(iii)))
        disp('Nannaa')
    end
end
if length(ind3)>0
    disp([num2str(length(ind3)),' NaN values in x3 removed'])
end



% Transform data to the interval [0,1]
x1MIN = min(x1(:));
x1MAX = max(x1(:));
x2MIN = min(x2(:));
x2MAX = max(x2(:));
x3MIN = min(x3(:));
x3MAX = max(x3(:));
x1 = x1-x1MIN;
x1 = x1/(x1MAX-x1MIN);
x2 = x2-x2MIN;
x2 = x2/(x2MAX-x2MIN);
x3 = x3-x3MIN;
x3 = x3/(x3MAX-x3MIN);



% Save to file
save Highamdata_3seasons x2 x1 x3 y x3MIN x3MAX x2MIN x2MAX x1MIN x1MAX Nweather



