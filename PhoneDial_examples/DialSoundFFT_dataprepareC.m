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
save tensounds s1 s2 s3 s4 s5 s6 s7 s8 s9 s0 sf