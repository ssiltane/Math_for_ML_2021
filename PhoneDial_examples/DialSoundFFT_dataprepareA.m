% FFT analysis of phone number dial sounds
%
% Samuli Siltanen Feb 2021

% Read in the sounds and crop them
[s3,sf] = audioread('data/Numero3.m4a');
time3=(1:size(s3))/sf;
figure(3)
clf
plot(s3);
title('number 3 sound signal')
% extract only the first column
s3 = s3(130000:160000,1);

[s7,sf] = audioread('data/Numero7.m4a');
time7=(1:size(s7))/sf;
figure(7)
clf
plot(s7);
title('number 7 sound signal')
% extract only the first column
s7 = s7(130000:160000,1);

% Listen to the sounds
sound(s3,sf)
pause(1)
sound(s7,sf)


%% Calculate FFT and plot

% Calculate FFT
shiftFFT=true;
[Fs3,freq3] = easyFFT(s3,sf,shiftFFT);
[Fs7,freq7] = easyFFT(s7,sf,shiftFFT);

% Crop the FFTs
ind1 = round(.45*length(Fs3));
ind2 = round(.55*length(Fs3));
Fs3 = Fs3(ind1:ind2);
Fs7 = Fs7(ind1:ind2);
freq3 = freq3(ind1:ind2);
freq7 = freq7(ind1:ind2);

% Plot
figure(30)
clf
plot(freq3,abs(Fs3),'r')
hold on
plot(freq3,abs(Fs7),'b')
axis square
title('FFT of the signals')
legend('Number 3', 'Number 7');
xlabel('freq (Hz)')

%% Save results to file

save data/twosounds s3 s7 sf
