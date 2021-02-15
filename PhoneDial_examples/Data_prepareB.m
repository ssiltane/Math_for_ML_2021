% Read in the sound signals of numbers 3 and 7, and pick out just the
% beeps.
%
% Samuli Siltanen Feb 2021

% Read in the sound signal to Matlab
[s,sf] = audioread('data/Numbers_3_and_7.WAV');

% Plot the signal
figure(1)
clf
plot(s)

% Pick out the signals
s3 = s(535000:570000);
s7 = s(660000:695000);

% Hear the the sounds
sound(s3,sf)
pause(1)
sound(s7,sf)

% Calculate the fft
fs3 = fft(s3);
fs3 = fftshift(fs3);
figure(1)
clf
plot(abs(fs3))
xlim([1 length(s3)])


