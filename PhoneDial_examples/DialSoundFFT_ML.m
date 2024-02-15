% Divide phone dial sounds into several samples


%% Put data snippets into matrices

% Load precomputed data
load data/twosounds s3 s7 
len = length(s3);

% Initialize sample matrices
N = 2^11;
K = floor(len/N);
s3mat = zeros(N,K);
s7mat = zeros(N,K);

%% Chop the original signals into K snippets, each stored as one column in
% the corresponding matrix
for iii = 1:K
    s3mat(:,iii) = s3((iii-1)*N+[1:N]);
    s7mat(:,iii) = s7((iii-1)*N+[1:N]);
end

%% Plot
figure(1)
clf
plot(s3mat,'r')
hold on
plot(s7mat,'b')
axis square
title('Signal snippets (3: red, 7:blue)');

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
title('Cropped FFT (central segment)')


%% Train Support Vector Machine (SVM) with *sound* data (bad idea)

% Use 2*Ntrain samples of the data to train an SVM
Ntrain1 = 5;
X = [(s3mat(:,1:Ntrain1)).';(s7mat(:,1:Ntrain1)).'];
Y = [3*ones(Ntrain1,1);7*ones(Ntrain1,1)];
svm1 = fitcsvm(X,Y);

% See how the svm performs with the remaining samples
predict3 = predict(svm1,(s3mat(:,(Ntrain1+1):end)).');
predict7 = predict(svm1,(s7mat(:,(Ntrain1+1):end)).') 


%% Train Support Vector Machine (SVM) with *FFT* data (good idea)

% Use 2*Ntrain samples of the data to train an SVM
Ntrain = 5;
X = [abs(Fs3mat(:,1:Ntrain)).';abs(Fs7mat(:,1:Ntrain)).'];
Y = [3*ones(Ntrain,1);7*ones(Ntrain,1)];
svm = fitcsvm(X,Y);

% See how the svm performs with the remaining samples
predict3 = predict(svm,abs(Fs3mat(:,(Ntrain+1):end)).') 
predict7 = predict(svm,abs(Fs7mat(:,(Ntrain+1):end)).') 



