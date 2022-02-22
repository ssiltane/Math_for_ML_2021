% Learn to classify three dial tones (1, 5, and 9) using three neurons,
% sigmoid activation and least squares fitting
%
% Samuli Siltanen February 2021
clear all;
close all;

% Graphical parameters
fsize = 16;
msize = 20;
msize2 = 10;

% Load data that was prepared in the routine DialSoundFFT_dataprepareC.m
load data/tensounds_matrices s1mat  s5mat  s9mat  sf N K

% Build a matrix containing samples of training data as columns: digit 1, digit 5 and digit 9 in this order
Ntrain = 5; % How many samples of each dial tone to use
X = [s1mat(:,1:Ntrain),s5mat(:,1:Ntrain),s9mat(:,1:Ntrain)];

% Build a big matrix containing samples of all the data as columns: digit 1, digit 5 and digit 9 in this order
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

% Determine length of data vector and number of Training sample
L = size(FX,1);
N = size(FX,2);

% We consider a very simple neural network with only three neurons in one 
% layer. This is the equation of this layer
%
% S(Ax+b) = y
% 
% where S(v) = 1/(1+exp(-v)) is the sigmoid activation function computed element-wise
% A is 3xL weight matrix
% x is Lx1 input vector (FFT of the input signals)
% b is 3x1 bias vector
% y is 3x1 output vector

% We wish to have the following output:
% Dial tone 1: output y1 = [ 1   0   0 ]^T
% Dial tone 5: output y5 = [ 0   1   0 ]^T
% Dial tone 9: output y9 = [ 0   0   1 ]^T

% since the sigmoid function S(v): R --> ]0,1[, we will require the outputs
% to be around 0.9 and 0.1, so in practice we will admit

% Dial tone 1: output y1 = [ 0.9   0.1   0.1 ]^T
% Dial tone 5: output y5 = [ 0.1   0.9   0.1 ]^T
% Dial tone 9: output y9 = [ 0.1   0.1   0.9 ]^T
outputHigh=0.9;
outputlow=0.1;

y1= [outputHigh*ones(Ntrain,1) outputlow*ones(Ntrain,1) outputlow*ones(Ntrain,1)];
y5= [outputlow*ones(Ntrain,1) outputHigh*ones(Ntrain,1) outputlow*ones(Ntrain,1)];
y9= [outputlow*ones(Ntrain,1) outputlow*ones(Ntrain,1) outputHigh*ones(Ntrain,1)];

% build a single output matrix by stacking the outputs of digit 1, 5, and 9 in this order
Y=[y1;y5;y9];

% We can train this network using Least squares 

%  S(Ax+b)=y    <=>  Ax+b = S^{-1}(y)
% where  S^{-1} is the inverse sigmoid function.

% Least square equation

% |  [ FFT_1^T ]  1  |   |  [     ]  |   |  [  ~y_1  ]  |
% |  [ FFT_2^T ]  1  |   |  [ A^T ]  |   |  [  ~y_2  ]  |
% |       ...        | * |  [     ]  | = |      ...     |
% |       ...        |   |  [     ]  |   |      ...     |
% |  [ FFT_N^T ]  1  |   |  [ b^T ]  |   |  [  ~y_N  ]  |
%
% where  ~y_i = S^{-1}(y_i)
%
%  Lets define the matrices as follows
%    E_{N x (L+1)}   *   P_{ L+1 x 3 } =  Y_tilde{ N x 3 }

% build matrices E and Y_tilde from training set: digit 1, 5, 9 in this order

E=[FX.' ones(N,1)];
Y_tilde= -log(1./Y - 1);  % inverse sigmoid function applied to Y

% solve least Squares using the pseudo inverse
P=pinv(E)*Y_tilde;

% extract A and b from matrix P

A=P(1:end-1,:)';
b=P(end,:)';

%% Check the result visually
figure(2)
clf
hold on

% run the newtowk for all input data  FXall.

for ii=1:size(FXall,2)
    y=A*FXall(:,ii)+b;
    % apply sigmoid activation function S
    y = 1./(1+exp(-y));
    
    % Plot classifications of dial tones: digit 1 (red), digit 5 (black),
    % digit 9 (blue)
    
    if ii<=19
        color='rs';
    elseif ii<=19*2
        color='k^';
    else
        color='bp';
    end
    plot3(y(1),y(2),y(3),color)
    title('red: 1 / blue: 5 / black: 9')
end









