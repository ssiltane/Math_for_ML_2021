% FFT analysis of phone number dial sounds
%
% Samuli Siltanen Feb 2021

% Read in the sounds and crop them
[s,sf] = audioread('data/Numerot1234567890.WAV');

% Plot the signal
figure(1)
clf
plot(s)

% Pick out the signals
s1 = s(160000+[1:40000]);
s2 = s(245000+[1:40000]);
s3 = s(326000+[1:40000]);
s4 = s(426000+[1:40000]);
s5 = s(510000+[1:40000]);
s6 = s(600000+[1:40000]);
s7 = s(685000+[1:40000]);
s8 = s(769000+[1:40000]);
s9 = s(854000+[1:40000]);
s0 = s(943000+[1:40000]);

% Listen to the sounds
sound(s1,sf)
pause(1)
sound(s2,sf)
pause(1)
sound(s3,sf)
pause(1)
sound(s4,sf)
pause(1)
sound(s5,sf)
pause(1)
sound(s6,sf)
pause(1)
sound(s7,sf)
pause(1)
sound(s8,sf)
pause(1)
sound(s9,sf)
pause(1)
sound(s0,sf)

% Save the sounds to file
save data/tensounds s1 s2 s3 s4 s5 s6 s7 s8 s9 s0 sf


%% Divide the data into shorter snippets

% Length of data vector (sound snippet) for learning
N = 2^11; 

% How many sound snippets we can take from a signal of length "len"
K = floor(len/N); 

% Initialize sample matrices as zero matrices of correct size
s1mat = zeros(N,K);
s2mat = zeros(N,K);
s3mat = zeros(N,K);
s4mat = zeros(N,K);
s5mat = zeros(N,K);
s6mat = zeros(N,K);
s7mat = zeros(N,K);
s8mat = zeros(N,K);
s9mat = zeros(N,K);
s0mat = zeros(N,K);

% Chop the original signals into K snippets, each stored as one column in
% the corresponding matrix
for iii = 1:K
    s1mat(:,iii) = s1((iii-1)*N+[1:N]);
    s2mat(:,iii) = s2((iii-1)*N+[1:N]);
    s3mat(:,iii) = s3((iii-1)*N+[1:N]);
    s4mat(:,iii) = s4((iii-1)*N+[1:N]);
    s5mat(:,iii) = s5((iii-1)*N+[1:N]);
    s6mat(:,iii) = s6((iii-1)*N+[1:N]);
    s7mat(:,iii) = s7((iii-1)*N+[1:N]);
    s8mat(:,iii) = s8((iii-1)*N+[1:N]);
    s9mat(:,iii) = s9((iii-1)*N+[1:N]);
    s0mat(:,iii) = s0((iii-1)*N+[1:N]);
end

save data/tensounds_matrices s1mat s2mat s3mat s4mat s5mat s6mat s7mat s8mat s9mat s0mat sf N K 
