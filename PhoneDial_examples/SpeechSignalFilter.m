% Read in the speech signal and filter it.
%
% Samuli Siltanen Feb 2021

% Read in the speech signal to Matlab
[s,sf] = audioread('data/SpeechSample.WAV');
s = s(120000:250000);

% Plot the signal
figure(1)
clf
plot(s)

% Calculate the fft
fs = fft(s);
fs = fftshift(fs);

% Filter the speech signal
modfs = fs;
n = (length(s)-1)/2;
tmp = [-n:n];
% Low-pass filter
modfs(abs(tmp)>n/20) = 0;
% High-pass filter
%modfs(abs(tmp)<n/20) = 0;
s2 = real(ifft(fftshift(modfs)));

% Take a look
figure(1)
clf
subplot(2,1,1)
plot(abs(fs))
xlim([1 length(s)])
subplot(2,1,2)
plot(abs(modfs))
xlim([1 length(s)])

% Hear the original sound and modified sound
sound(s,sf)
pause(4)
sound(s2,sf)