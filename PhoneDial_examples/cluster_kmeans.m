% Clustering the ten dial tone sounds using the k-means algorithm.
%
% Samuli Siltanen Feb 2021

%% Preliminaries

% Load data prepared by routine DialSoundFFT_dataprepareC.m
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

%% Test kmeans without PCA

% First, let's try to cluster the sound sample data with kmeans. We expect
% this to fail. The columns of the displayed matrix "result1" should belong 
% in the same cluster. So if any column has more than one number appearing
% in it, the clustering went wrong. 
clusters_sound = kmeans(X.',10);
result1 = reshape(clusters_sound,[Ntrain,10]);
disp(result1)

% Second, let's cluster the Fourier transformed and cropped samples. This
% goes right most of the time, seen as constant columns in the matrix
% result2. Try running this many times, and you see that sometimes k-means
% fails in some of the columns. 
[clusters_FFT,centers] = kmeans(FX.',10);
result2 = reshape(clusters_FFT,[Ntrain,10]);
disp(result2)

% Third, let's see how well the clustering generalizes to data points not
% used in the kmeans algorithm. If the clustering is correct, the columns
% of matrix result3 are constant. 
result3 = -1*ones(K,10);
for iii = 1:(K*10)
    % Take one sample at a time
    curr_sample = FXall(:,iii); 
   
    % Check which cluster center is the closest
    distvec = zeros(1,10);
    for jjj=1:10
          distvec(jjj) = norm(centers(jjj,:)-curr_sample(:).');
    end
    index = min(find(distvec==min(distvec)));
    
    % Record the result
    result3(iii) = index;
end
disp(result3)



