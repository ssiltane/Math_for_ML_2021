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
shiftFFT=true;
[fs,freq] = easyFFT(s,sf,shiftFFT);

% Filter the speech signal
cutoffFreq=2000; % value in Hz
modfs = fs;
% Low-pass filter
modfs(abs(freq)>cutoffFreq) = 0;
% High-pass filter
%modfs(abs(freq)<cutoffFreq) = 0;
s2 = real(ifft(fftshift(modfs)));

% Take a look
figure(1)
clf
subplot(2,1,1)
plot(freq,abs(fs))
xlabel('frequency (Hz)')
subplot(2,1,2)
plot(freq,abs(modfs))
xlabel('frequency (Hz)')

% Hear the original sound and modified sound
sound(s,sf)
pause(4)
sound(s2,sf)