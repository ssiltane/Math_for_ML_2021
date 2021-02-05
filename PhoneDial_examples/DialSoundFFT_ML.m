% Divide phone dial sounds into several samples
%
% Samuli Siltanen Feb 2021

%% Put data snippets into matrices

% Load precomputed data
load data/twosounds s3 s7 fs
len = length(s3);

% Initialize sample matrices
N = 2^11;
K = floor(len/N);
s3mat = zeros(N,K);
s7mat = zeros(N,K);

% Chop the original signals into K snippets, each stored as one column in
% the corresponding matrix
for iii = 1:K
    s3mat(:,iii) = s3((iii-1)*N+[1:N]);
    s7mat(:,iii) = s7((iii-1)*N+[1:N]);
end


%% Calculate FFTs

% Fast Fourier transform applied to columns
Fs3mat = fftshift(fft(s3mat),1);
Fs7mat = fftshift(fft(s7mat),1);

% Crop the FFTs
ind1 = round(.45*size(Fs3mat,1));
ind2 = round(.55*size(Fs3mat,1));
Fs3mat = Fs3mat(ind1:ind2,:);
Fs7mat = Fs7mat(ind1:ind2,:);


% Plot
figure(30)
clf
plot(abs(Fs3mat),'r')
hold on
plot(abs(Fs7mat),'b')
axis square
xlim([1 size(Fs3mat,1)])


%% Calculate svm

% Use 20 samples of the data to train an SVM
X = [abs(Fs3mat(:,1:10)).';abs(Fs7mat(:,1:10)).'];
Y = [3*ones(10,1);7*ones(10,1)];
svm = fitcsvm(X,Y);

% See how the svm performs with the remaining 8 samples
predict(svm,abs(Fs3mat(:,11:end)).') 
predict(svm,abs(Fs7mat(:,11:end)).') 