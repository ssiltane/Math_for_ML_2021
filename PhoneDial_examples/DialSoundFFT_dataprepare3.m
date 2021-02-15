% FFT analysis of phone number dial sounds
%
% Samuli Siltanen Feb 2021

% Read in the sounds and crop them
[s,fs] = audioread('data/Numerot1234567890.WAV');
figure(1)
clf
plot(s)


% Listen to the sounds
% sound(s3,fs)
% pause(1)
% sound(s7,fs)


%% Calculate FFT and plot

% % Calculate FFT
% Fs3 = fftshift(fft(s3));
% Fs7 = fftshift(fft(s7));
% 
% % Crop the FFTs
% ind1 = round(.45*length(Fs3));
% ind2 = round(.55*length(Fs3));
% Fs3 = Fs3(ind1:ind2);
% Fs7 = Fs7(ind1:ind2);
% 
% % Plot
% figure(30)
% clf
% plot(abs(Fs3),'r')
% hold on
% plot(abs(Fs7),'b')
% axis square
% xlim([1 length(Fs3)])

%% Save results to file

%save data/sounds 