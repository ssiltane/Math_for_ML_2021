% Apply Principal Component Analysis (PCA) to dial tone data
%
% Samuli Siltanen February 2021

% Graphical parameters
fsize = 16;
msize = 20;
msize2 = 10;

% Load data. Note that all the 10 data vectos have the same length
load data/tensounds_matrices s1mat s2mat s3mat s4mat s5mat s6mat s7mat s8mat s9mat s0mat sf N K

% Build a matrix containing samples of training data as columns
Ntrain = 5;
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
FXall = abs(FXall);

% Look at the FFTs. Note the seven spike locations at the frequencies used
% in the dial tone system (see https://onlinetonegenerator.com/dtmf.html)
figure(1)
clf
plot(FX(:,1:Ntrain),'r')
hold on
plot(FX(:,Ntrain+[1:Ntrain]),'b')
plot(FX(:,2*Ntrain+[1:Ntrain]),'k')
plot(FX(:,3*Ntrain+[1:Ntrain]),'g')


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
B = V(:,(end-2):end);

% Project the data onto the subspace spanned by the dominant eigenvectors
tmp1 = B.'*FXall;

figure(10)
clf
plot3(tmp1(1,1:K),tmp1(2,1:K),tmp1(3,1:K),'ro','markersize',msize2)
hold on 
plot3(tmp1(1,K+[1:K]),tmp1(2,K+[1:K]),tmp1(3,K+[1:K]),'bs','markersize',msize2)
hold on 
plot3(tmp1(1,2*K+[1:K]),tmp1(2,2*K+[1:K]),tmp1(3,2*K+[1:K]),'m^','markersize',msize2)
plot3(tmp1(1,3*K+[1:K]),tmp1(2,3*K+[1:K]),tmp1(3,3*K+[1:K]),'k*','markersize',msize2)
plot3(tmp1(1,4*K+[1:K]),tmp1(2,4*K+[1:K]),tmp1(3,4*K+[1:K]),'gp','markersize',msize2)
plot3(tmp1(1,5*K+[1:K]),tmp1(2,5*K+[1:K]),tmp1(3,5*K+[1:K]),'c.','markersize',msize)
p6 = plot3(tmp1(1,6*K+[1:K]),tmp1(2,6*K+[1:K]),tmp1(3,6*K+[1:K]),'cx','markersize',msize2);
set(p6,'color',[.5 .5 .5])
p7 = plot3(tmp1(1,7*K+[1:K]),tmp1(2,7*K+[1:K]),tmp1(3,7*K+[1:K]),'cd','markersize',msize2);
set(p7,'color',[.1 .5 .1])
p8 = plot3(tmp1(1,8*K+[1:K]),tmp1(2,8*K+[1:K]),tmp1(3,8*K+[1:K]),'c<','markersize',msize2);
set(p8,'color',[.3 .1 .8])
p9 = plot3(tmp1(1,9*K+[1:K]),tmp1(2,9*K+[1:K]),tmp1(3,9*K+[1:K]),'cv','markersize',msize2);
set(p9,'color',[.6 .1 .1])
title('Three dominant PCA dimensions, data not normalized','fontsize',fsize)



% Pick three most dominant eigenvectors from normalized PCA
B2 = V2(:,(end-2):end);

% Project the normalized data onto the subspace spanned by the dominant eigenvectors
tmp2 = B2.'*FXall2;

figure(11)
clf
plot3(tmp2(1,1:K),tmp2(2,1:K),tmp2(3,1:K),'ro','markersize',msize2)
hold on 
plot3(tmp2(1,K+[1:K]),tmp2(2,K+[1:K]),tmp2(3,K+[1:K]),'bs','markersize',msize2)
hold on 
plot3(tmp2(1,2*K+[1:K]),tmp2(2,2*K+[1:K]),tmp2(3,2*K+[1:K]),'m^','markersize',msize2)
plot3(tmp2(1,3*K+[1:K]),tmp2(2,3*K+[1:K]),tmp2(3,3*K+[1:K]),'k*','markersize',msize2)
plot3(tmp2(1,4*K+[1:K]),tmp2(2,4*K+[1:K]),tmp2(3,4*K+[1:K]),'gp','markersize',msize2)
plot3(tmp2(1,5*K+[1:K]),tmp2(2,5*K+[1:K]),tmp2(3,5*K+[1:K]),'c.','markersize',msize)
p6 = plot3(tmp2(1,6*K+[1:K]),tmp2(2,6*K+[1:K]),tmp2(3,6*K+[1:K]),'cx','markersize',msize2);
set(p6,'color',[.5 .5 .5])
p7 = plot3(tmp2(1,7*K+[1:K]),tmp2(2,7*K+[1:K]),tmp2(3,7*K+[1:K]),'cd','markersize',msize2);
set(p7,'color',[.1 .5 .1])
p8 = plot3(tmp2(1,8*K+[1:K]),tmp2(2,8*K+[1:K]),tmp2(3,8*K+[1:K]),'c<','markersize',msize2);
set(p8,'color',[.3 .1 .8])
p9 = plot3(tmp2(1,9*K+[1:K]),tmp2(2,9*K+[1:K]),tmp2(3,9*K+[1:K]),'cv','markersize',msize2);
set(p9,'color',[.6 .1 .1])
title('Three dominant PCA dimensions, normalized data','fontsize',fsize)



%% Dimension reduction: fourth and fifth dominant directions for non-normalized data

% B3 = V(:,(end-4):(end-3));
% tmp3 = B3.'*FXall;
% 
% figure(13)
% clf
% hold on 
% plot(tmp3(1,K+[1:K]),tmp3(2,K+[1:K]),'b.','markersize',msize)
% plot(tmp3(1,4*K+[1:K]),tmp3(2,4*K+[1:K]),'g.','markersize',msize)
% p7 = plot(tmp3(1,7*K+[1:K]),tmp3(2,7*K+[1:K]),'c.','markersize',msize);
% set(p7,'color',[.1 .5 .1])
% p9 = plot(tmp3(1,9*K+[1:K]),tmp3(2,9*K+[1:K]),'c.','markersize',msize);
% set(p9,'color',[.6 .1 .1])
% title('4th and 5th PCA dimensions, data not normalized','fontsize',fsize)



%% Dimension reduction: fourth, fifth and sixth dominant directions for normalized data


B4 = V2(:,(end-5):(end-3));
tmp4 = B4.'*FXall2;

figure(14)
clf
plot3(tmp4(1,1:K),tmp4(2,1:K),tmp4(3,1:K),'ro','markersize',msize2)
hold on 
plot3(tmp4(1,K+[1:K]),tmp4(2,K+[1:K]),tmp4(3,K+[1:K]),'bs','markersize',msize2)
hold on 
plot3(tmp4(1,2*K+[1:K]),tmp4(2,2*K+[1:K]),tmp4(3,2*K+[1:K]),'m^','markersize',msize2)
plot3(tmp4(1,3*K+[1:K]),tmp4(2,3*K+[1:K]),tmp4(3,3*K+[1:K]),'k*','markersize',msize2)
plot3(tmp4(1,4*K+[1:K]),tmp4(2,4*K+[1:K]),tmp4(3,4*K+[1:K]),'gp','markersize',msize2)
plot3(tmp4(1,5*K+[1:K]),tmp4(2,5*K+[1:K]),tmp4(3,5*K+[1:K]),'c.','markersize',msize)
p6 = plot3(tmp4(1,6*K+[1:K]),tmp4(2,6*K+[1:K]),tmp4(3,6*K+[1:K]),'cx','markersize',msize2);
set(p6,'color',[.5 .5 .5])
p7 = plot3(tmp4(1,7*K+[1:K]),tmp4(2,7*K+[1:K]),tmp4(3,7*K+[1:K]),'cd','markersize',msize2);
set(p7,'color',[.1 .5 .1])
p8 = plot3(tmp4(1,8*K+[1:K]),tmp4(2,8*K+[1:K]),tmp4(3,8*K+[1:K]),'c<','markersize',msize2);
set(p8,'color',[.3 .1 .8])
p9 = plot3(tmp4(1,9*K+[1:K]),tmp4(2,9*K+[1:K]),tmp4(3,9*K+[1:K]),'cv','markersize',msize2);
set(p9,'color',[.6 .1 .1])
title('4th-6th PCA dimensions, normalized data','fontsize',fsize)




