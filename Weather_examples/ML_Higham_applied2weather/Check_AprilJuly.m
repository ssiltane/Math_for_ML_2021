% Show quality of results in numbers
%
% Samuli Siltanen January 2021

% Load precomputed data
load Highamdata x2 x1 y Nweather
load NN_parameters W2 b2 W3 b3 W4 b4

% Initialize results
results_April = zeros(1,2);
results_July = zeros(1,2);

% Loop over data points (days)
for iii = 1:Nweather
    % Increment total counts according to data type (month)
    if y(1,iii)>y(2,iii)
        results_April(2) = results_April(2)+1;
    else
        results_July(2) = results_July(2)+1;
    end
    
    % Calculate the classification of the neural net
    a2 = activate([x1(iii);x2(iii)],W2,b2);
    a3 = activate(a2,W3,b3);
    a4 = activate(a3,W4,b4);
    
    % Record correct classifications
    if a4(1)>a4(2) & y(1,iii)>y(2,iii)
        results_April(1) = results_April(1)+1; 
    end
    if a4(1)<a4(2) & y(1,iii)<y(2,iii)
        results_July(1) = results_July(1)+1;
    end
end

% Results
perc_April = results_April(1)/results_April(2);
perc_July = results_July(1)/results_July(2);
disp([num2str(round(100*perc_April)),' % of April days correctly classified'])
disp([num2str(round(100*perc_July)),' % of July days correctly classified'])
