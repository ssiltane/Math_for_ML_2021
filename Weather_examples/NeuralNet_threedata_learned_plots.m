% Quantitative check of results for three seasons
%
% Samuli Siltanen, Jan 2021
%

%% Preliminaries

% Load precomputed stuff
load  ML_Higham_applied2weather_multi/Highamdata_3seasons x1 x2 x3 y Nweather
Ninput  = 3;
Noutput = size(y,1);
load data/NN_parameters_3seasons W2 b2 W3 b3 W4 b4

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


%% Show classification accuracy as a table

% Initialize results
results_January = zeros(1,2);
results_April = zeros(1,2);
results_July = zeros(1,2);
a4_all = zeros(3,Nweather);

% Loop over data points (days)
for iii = 1:Nweather
    % Increment total counts according to data type (month)
    ind1 = find(y(:,iii)>.5); % Find index of unique element that equals one
    switch ind1
        case 1
            results_January(2) = results_January(2)+1;
        case 2
            results_April(2) = results_April(2)+1;
        case 3
            results_July(2) = results_July(2)+1;
    end
    
    % Calculate the classification of the neural net
    a2 = activate([x1(iii);x2(iii);x3(iii)],W2,b2);
    a3 = activate(a2,W3,b3);
    a4 = activate(a3,W4,b4);
    a4_all(:,iii) = a4;
    
    % Record correct classifications
    if isnan(max(a4))
        disp('Nannaa')
        disp(iii)
    end
    ind2 = min(find(abs(a4-max(a4))<1e-8)); % Index of maximal element in vector a4
    switch ind2
        case 1
            if ind1==1 % Correct classification
                results_January(1) = results_January(1)+1;
            end
        case 2
            if ind1==2 % Correct classification
                results_April(1) = results_April(1)+1;
            end
        case 3
            if ind1==3 % Correct classification
                results_July(1) = results_July(1)+1;
            end
    end
end

% Results
perc_January = results_January(1)/results_January(2);
perc_April = results_April(1)/results_April(2);
perc_July = results_July(1)/results_July(2);
disp([num2str(round(100*perc_January)),' % of January days correctly classified'])
disp([num2str(round(100*perc_April)),' % of April days correctly classified'])
disp([num2str(round(100*perc_July)),' % of July days correctly classified'])




%% Plot the data to show how complicated it is

% Note that the data is still normalized to the interval [0,1]. Therefore
% the data points do not show the correct physical units.


figure(117)
clf
for iii = 1:length(x1)
    if y(1,iii)>0
        p1 = plot3(x1(iii),x2(iii),x3(iii),'bo','markersize',msize2);
        hold on
        set(p1,'color',color_winter)
        set(p1,'markerfacecolor',color_winter)
    end
    
    if y(2,iii)>0
        p1 = plot3(x1(iii),x2(iii),x3(iii),'bs','markersize',msize2);
        hold on
        set(p1,'color',color_spring)
        set(p1,'markerfacecolor',color_spring)
    end
    
    if y(3,iii)>0
        p1 = plot3(x1(iii),x2(iii),x3(iii),'bd','markersize',msize2);
        hold on
        set(p1,'color',color_summer)
        set(p1,'markerfacecolor',color_summer)
    end
end

