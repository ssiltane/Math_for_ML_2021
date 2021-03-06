% Learn to classify three dial tones (1, 5, and 9) using three neurons,
% sigmoid activation and least squares fitting
%
% Samuli Siltanen February 2021

% Graphical parameters
fsize = 16;
msize = 20;
msize2 = 10;

% Load data that was prepared in the routine DialSoundFFT_dataprepareC.m
load data/tensounds_matrices s1mat  s5mat  s9mat  sf N K

% Build a matrix containing samples of training data as columns
Ntrain = 5; % How many samples of each dial tone to use
X = [s1mat(:,1:Ntrain),s5mat(:,1:Ntrain),s9mat(:,1:Ntrain)];

% Build a big matrix containing samples of all the data as columns
Xall = [s1mat,s5mat,s9mat];


%% Preprocess data for learning by calculating FFTs 

% Fast Fourier transform applied to columns, with appropriate fftshift
% placing zero frequency to the middle of the vector
FX = fftshift(fft(X),1);
FXall = fftshift(fft(Xall),1);

% Crop the FFTs to the part where the information is. This is a kind of
% dimension reduction. Due to symmetry with respect to the middle of the
% vector, we only take elements from the second half of the vector. 
ind1 = round(.513*size(FX,1));
ind2 = round(.538*size(FX,1));
FX = FX(ind1:ind2,:);
FXall = FXall(ind1:ind2,:);

% Take absolute value of the complex-valued FFTs
FX = abs(FX);
len = size(FX,1);
FXall = abs(FXall);

% Look at the FFTs. Note the seven spike locations at the frequencies used
% in the dial tone system (see https://onlinetonegenerator.com/dtmf.html)
figure(1)
clf
for iii = 1:3
    subplot(3,1,iii)
    plot(FX(:,(iii-1)*Ntrain+[1:Ntrain]),'r')
    xlim([1 len])
    set(gca,'xticklabel',{})
    set(gca,'yticklabel',{})
    box off
    pbaspect([8 1 1])
end

%% Learning by least squares

% Determine length of data vectors
L = size(FXall,1);

% We consider a very simple neural network with only three neurons in one 
% layer. We wish to have the following output:
% Dial tone 1: output op1 = [s(5) s(-5) s(-5)]^T
% Dial tone 5: output op5 = [s(-5) s(5) s(-5)]^T
% Dial tone 9: output op9 = [s(-5) s(-5) s(5)]^T
% Here s denotes the smooth sigmoid function s(z) = 1/(1+exp(-z)). 
% Given a vertical input vector f1 corresponding to dial tone 1, we have 
% the matrix equation W*f1+b = [5 -5 -5]^T, where matrix W has 3 rows and L
% columns. We can also write it in another way. Denote W^T = [Wx Wy Wz],
% where Wx, Wy and Wz are vertical L-vectors. We set b=0.
% Then we have three equations:
% f1^T*Wx = 5
% f1^T*Wy = -5
% f1^T*Wz = -5
% For a dial tone 5 data vector we must have 
% f5^T*Wx = -5
% f5^T*Wy = 5
% f5^T*Wz = -5
% Further, for a dial tone 9 data vector we must have 
% f9^T*Wx = -5
% f9^T*Wy = -5
% f9^T*Wz = 5
% Of course, we have many different data vectors, and there are no vectors
% Wx and Wy and Wz that would satisfy them all. But we can use least
% squares!
rhs_x = [5*ones(Ntrain,1);-5*ones(Ntrain,1);-5*ones(Ntrain,1)];
Wx = (FX.')\rhs_x;
rhs_y = [-5*ones(Ntrain,1);5*ones(Ntrain,1);-5*ones(Ntrain,1)];
Wy = (FX.')\rhs_y;
rhs_z = [-5*ones(Ntrain,1);-5*ones(Ntrain,1);5*ones(Ntrain,1)];
Wz = (FX.')\rhs_z;

% Check the result numerically
%disp(reshape(Wx.'*FXall,19,3))
%disp(reshape(Wy.'*FXall,19,3))
%disp(reshape(Wz.'*FXall,19,3))

% Check the result visually
figure(1)
clf
hold on
% Plot classifications of dial tones for digit 1 in red
for iii = 1:19
    x = Wx.'*FXall(:,iii);
    x = 1/(1+exp(-x));
    y = Wy.'*FXall(:,iii);
    y = 1/(1+exp(-y));
    z = Wz.'*FXall(:,iii);
    z = 1/(1+exp(-z));
    plot3(x,y,z,'rs')
end
% Plot classifications of dial tones for digit 5 in black
for iii = 1:19
    x = Wx.'*FXall(:,19+iii);
    x = 1/(1+exp(-x));
    y = Wy.'*FXall(:,19+iii);
    y = 1/(1+exp(-y));
    z = Wz.'*FXall(:,19+iii);
    z = 1/(1+exp(-z));
    plot3(x,y,z,'k^')
end
% Plot classifications of dial tones for digit 9 in blue
for iii = 1:19
    x = Wx.'*FXall(:,2*19+iii);
    x = 1/(1+exp(-x));
    y = Wy.'*FXall(:,2*19+iii);
    y = 1/(1+exp(-y));
    z = Wz.'*FXall(:,2*19+iii);
    z = 1/(1+exp(-z));
    plot3(x,y,z,'bp')
end






