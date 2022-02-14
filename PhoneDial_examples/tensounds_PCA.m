% Apply Principal Component Analysis (PCA) to dial tone data
%
% Samuli Siltanen February 2021

% Graphical parameters
fsize = 16;
msize = 20;
msize2 = 8;

% Load data that was prepared in the routine DialSoundFFT_dataprepareC.m
load data/tensounds_matrices s1mat s2mat s3mat s4mat s5mat s6mat s7mat s8mat s9mat s0mat sf N K

% Build a matrix containing samples of training data as columns
Ntrain = 5; % How many samples of each dial tone to use
X = [s1mat(:,1:Ntrain),s2mat(:,1:Ntrain),s3mat(:,1:Ntrain),s4mat(:,1:Ntrain),s5mat(:,1:Ntrain),s6mat(:,1:Ntrain),s7mat(:,1:Ntrain),s8mat(:,1:Ntrain),s9mat(:,1:Ntrain),s0mat(:,1:Ntrain)];

% Build a big matrix containing samples of all the data as columns
Xall = [s1mat,s2mat,s3mat,s4mat,s5mat,s6mat,s7mat,s8mat,s9mat,s0mat];


%% Calculate FFTs

% Fast Fourier transform applied to columns, with appropriate fftshift
% placing zero frequency to the middle of the vector
FX = fftshift(fft(X),1);
FXall = fftshift(fft(Xall),1);

% Crop the FFTs to the part where the information is. This is a kind of
% dimension reduction. Due to symmetry with respect to the middle of the
% vector, we only take elements from the second half of the vector. 
ind1 = round(.505*size(FX,1));
ind2 = round(.55*size(FX,1));
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
for iii = 1:10
    subplot(10,1,iii)
    plot(FX(:,(iii-1)*Ntrain+[1:Ntrain]),'r')
    xlim([1 len])
    set(gca,'xticklabel',{})
    set(gca,'yticklabel',{})
    box off
    pbaspect([8 1 1])
end

% figure(2)
% clf
% plot(FX(:,1:Ntrain),'r')
% hold on
% plot(FX(:,Ntrain+[1:Ntrain]),'b')
% plot(FX(:,2*Ntrain+[1:Ntrain]),'k')
% plot(FX(:,3*Ntrain+[1:Ntrain]),'g')


%% Compute Principal Component Analysis with and without normalization

% Calculate the eigenvalues and eigenvectors of the *non-normalized* data
% covariance matrix S
S = FX*FX.';
S = S/size(FX,2);
[V,D] = eig(S);

% Normalize training data so that it becomes zero-mean and unit-variance
dataMEAN = mean(FX.').';
FX2 = FX-repmat(dataMEAN,1,size(FX,2));
dataSTD = std(FX2.').';
FX2 = FX2./repmat(dataSTD,1,size(FX2,2));

% Calculate the eigenvalues and eigenvectors of the normalized data
% covariance matrix S2
S2 = FX2*FX2.';
S2 = S2/size(FX2,2);
[V2,D2] = eig(S2);

% Normalize the full data matrix, so we can test how PCA maps data vectors
% that were not used in the computation of the principal components
FXall2 = FXall-repmat(dataMEAN,1,size(FXall,2));
FXall2 = FXall2./repmat(dataSTD,1,size(FXall2,2));


%% Dimension reduction, version 1: Three most dominant dimensions

% Pick three most dominant eigenvectors (non-normalized PCA)
% note the largest elements in D is the last components.
B = V(:,(end-2):end);

% Project the data onto the subspace spanned by the dominant eigenvectors
tmp1 = B.'*FXall;

plot3_Digits(10,reshape(tmp1,3,K,10))
title('Three dominant PCA dimensions, data not normalized','fontsize',fsize)

% Pick three most dominant eigenvectors from normalized PCA
B2 = V2(:,(end-2):end);

% Project the normalized data onto the subspace spanned by the dominant eigenvectors
tmp2 = B2.'*FXall2;

plot3_Digits(11,reshape(tmp2,3,K,10))
title('Three dominant PCA dimensions, normalized data','fontsize',fsize)


%% Dimension reduction: fourth and fifth dominant directions for non-normalized data

% B3 = V(:,(end-4):(end-3));
% tmp3 = B3.'*FXall;
% 
%plot3_Digits(11,reshape(tmp3,3,K,10))
% title('4th and 5th PCA dimensions, data not normalized','fontsize',fsize)


%% Dimension reduction: fourth, fifth and sixth dominant directions for normalized data

B4 = V2(:,(end-5):(end-3));
tmp4 = B4.'*FXall2;

plot3_Digits(13,reshape(tmp4,3,K,10))
title('4th-6th PCA dimensions, normalized data','fontsize',fsize)




