%NETBP_FULL
%   Extended version of netbp, with more graphics
%
%   Set up data for neural net test
%   Use backpropagation to train
%   Visualize results
%
% C F Higham and D J Higham, Aug 2017
% Modified by Samuli Siltanen, Jan 2021

% Training parameters
eta = 0.0005;
Niter = 10000000;
noise_amp = .6;

% Network architecture
N1 = 5;  % Number of neurons in layer 1
N2 = 7; % Number of neurons in layer 2


%%%%%%% DATA %%%%%%%%%%%
% xcoords, ycoords, targets
load  Highamdata_3seasons  x1 x2 x3 y Nweather
x1_orig = x1;
x2_orig = x2;
x3_orig = x3;
y_orig = y;
Nweather_orig = Nweather;
days_ind = [1,31,61,91,121,151,181,211,241,...
    2,32,62,92,122,152,182,212,242,...
    3,33,63,93,123,153,183,213,243,...
    4,34,64,94,124,154,184,214,244,...
    5,35,65,95,125,155,185,215,245,...
    6,36,66,96,126,156,186,216,246,...
    7,37,67,97,127,157,187,217,247,...
    8,38,68,98,128,158,188,218,248,...
    9,39,69,99,129,159,189,219,249,...
    10,40,70,100,130,160,190,220,250];
Nweather = length(days_ind);
x1  = x1(days_ind);
x2  = x2(days_ind);
x3  = x3(days_ind);
y   = y(:,days_ind);
Ninput  = 3;
Noutput = size(y,1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize weights and biases
%rng(3000);
W2 = noise_amp*randn(N1,Ninput);
W3 = noise_amp*randn(N2,N1);
W4 = noise_amp*randn(Noutput,N2);
b2 = noise_amp*randn(N1,1);
b3 = noise_amp*randn(N2,1);
b4 = noise_amp*randn(Noutput,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Forward and Back propagate
% Pick a training point at random
tic
savecost = zeros(Niter,1);
saveJan_orig = [];
saveJan = [];
saveApr_orig = [];
saveApr = [];
saveJul_orig = [];
saveJul = [];
saveIter = [];
for counter = 1:Niter
    k = randi(Nweather);
    x = [x1(k); x2(k); x3(k)];
    % Forward pass
    a2 = activate(x,W2,b2);
    a3 = activate(a2,W3,b3);
    a4 = activate(a3,W4,b4);
    % Backward pass
    delta4 = a4.*(1-a4).*(a4-y(:,k));
    delta3 = a3.*(1-a3).*(W4'*delta4);
    delta2 = a2.*(1-a2).*(W3'*delta3);
    % Gradient step
    W2 = W2 - eta*delta2*x';
    W3 = W3 - eta*delta3*a2';
    W4 = W4 - eta*delta4*a3';
    b2 = b2 - eta*delta2;
    b3 = b3 - eta*delta3;
    b4 = b4 - eta*delta4;
    
    % Monitor progress
    newcost = cost3(W2,W3,W4,b2,b3,b4,Nweather,x1,x2,x3,y);
    savecost(counter) = newcost;
    if mod(counter,round(Niter/50))==3
        
        % Initialize quantitative error measures
        results_orig_January = zeros(1,2);
        results_orig_April = zeros(1,2);
        results_orig_July = zeros(1,2);
        
        % Loop over data points (days)
        for iii = 1:Nweather_orig  
            % Increment total counts according to data type (month)
            ind1 = find(y_orig(:,iii)>.5); % Find index of unique element that equals one
            switch ind1
                case 1
                    results_orig_January(2) = results_orig_January(2)+1;
                case 2
                    results_orig_April(2) = results_orig_April(2)+1;
                case 3
                    results_orig_July(2) = results_orig_July(2)+1;
            end
            
            % Calculate the classification of the neural net
            a2 = activate([x1_orig(iii);x2_orig(iii);x3_orig(iii)],W2,b2);
            a3 = activate(a2,W3,b3);
            a4 = activate(a3,W4,b4);
            
            % Record correct classifications
            ind2 = min(find(abs(a4-max(a4))<1e-8)); % Index of maximal element in vector a4
            switch ind2
                case 1
                    if ind1==1 % Correct classification
                        results_orig_January(1) = results_orig_January(1)+1;
                    end
                case 2
                    if ind1==2 % Correct classification
                        results_orig_April(1) = results_orig_April(1)+1;
                    end
                case 3
                    if ind1==3 % Correct classification
                        results_orig_July(1) = results_orig_July(1)+1;
                    end
            end
        end
        
        % Quantitative results
        if results_orig_January(2)<1
            perc_orig_January = -1;
        else
            perc_orig_January = results_orig_January(1)/results_orig_January(2);
        end
        if results_orig_April(2)<1
            perc_orig_April = -1;
        else
            perc_orig_April = results_orig_April(1)/results_orig_April(2);
        end
        if results_orig_July(2)<1
            perc_orig_July = -1;
        else
            perc_orig_July = results_orig_July(1)/results_orig_July(2);
        end
        
        % Initialize quantitative error measures, for training data only
        results_January = zeros(1,2);
        results_April = zeros(1,2);
        results_July = zeros(1,2);
        
        % Loop over data points (days)
        for jjj = 1:length(days_ind)
            % Increment total counts according to data type (month)
            ind1 = find(y(:,jjj)>.5); % Find index of unique element that equals one
            switch ind1
                case 1
                    results_January(2) = results_January(2)+1;
                case 2
                    results_April(2) = results_April(2)+1;
                case 3
                    results_July(2) = results_July(2)+1;
            end
            
            % Calculate the classification of the neural net
            a2 = activate([x1(jjj);x2(jjj);x3(jjj)],W2,b2);
            a3 = activate(a2,W3,b3);
            a4 = activate(a3,W4,b4);
            
            % Record correct classifications
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
        
        % Quantitative results
        if results_January(2)<1
            perc_January = -1;
        else
            perc_January = results_January(1)/results_January(2);
        end
        if results_April(2)<1
            perc_April = -1;
        else
            perc_April = results_April(1)/results_April(2);
        end
        if results_July(2)<1
            perc_July = -1;
        else
            perc_July = results_July(1)/results_July(2);
        end
        
        disp([num2str(counter/Niter,'%0.2f'),'   ', num2str(newcost,'%f')])
        % Plot results
        figure(2)
        clf
        semilogy([1:1e4:Niter],savecost(1:1e4:Niter),'b-','LineWidth',2)
        xlabel('Iteration Number')
        ylabel('Value of cost function')
        title(['Accuracy: January ',...
            num2str(round(100*perc_January)),'%(',num2str(round(100*perc_orig_January)),'%), April ',...
            num2str(round(100*perc_April)),'%(',num2str(round(100*perc_orig_April)),'%), July ',...
            num2str(round(100*perc_July)),'%(',num2str(round(100*perc_orig_July)),'%)'])
        set(gca,'FontWeight','Bold','FontSize',18)
        xlim([0 Niter])
        drawnow
        
        
        figure(3)
        clf
        saveJan_orig = [saveJan_orig,perc_orig_January];
        saveJan = [saveJan,perc_January];
        saveApr_orig = [saveApr_orig,perc_orig_April];
        saveApr = [saveApr,perc_April];
        saveJul_orig = [saveJul_orig,perc_orig_July];
        saveJul = [saveJul,perc_July];
        saveIter = [saveIter,counter];
        plot(saveIter,100*saveJan,'r','linewidth',2)
        hold on
        plot(saveIter,100*saveJan_orig,'r--','linewidth',2)
        plot(saveIter,100*saveApr,'g','linewidth',2)
        plot(saveIter,100*saveApr_orig,'g--','linewidth',2)
        plot(saveIter,100*saveJul,'b','linewidth',2)
        plot(saveIter,100*saveJul_orig,'b--','linewidth',2)
        set(gca,'FontWeight','Bold','FontSize',18)
        axis([0 Niter -2 102])
        drawnow        
    end
end

disp(['Computation took ',num2str(toc),' seconds'])

% Plot results
figure(2)
clf
semilogy([1:1e4:Niter],savecost(1:1e4:Niter),'b-','LineWidth',2)
xlabel('Iteration Number')
ylabel('Value of cost function')
set(gca,'FontWeight','Bold','FontSize',18)
%print -dpng pic_cost.png

% Save learned coefficients to file
save NN_parameters_3seasons W2 b2 W3 b3 W4 b4


% Check the quality of results
checkresults_3seasons