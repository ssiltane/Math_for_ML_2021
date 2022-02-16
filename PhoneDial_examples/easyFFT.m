function [X,freq]=easyFFT(signal,Fs,shiftFFT)
% Computes the FFT and creates the associated frequency vector
%  [X,freq]=easyFFT(signal,Fs,shiftFFT)
%
%   arguments:
%-- signal             Input signal in time domain. If 'signal' is a matrix, then computes the FFT for each column.
%-- Fs                 sampling frequency
%-- shiftFFT           booleand indicating if we want to shift the fft.
%
%   output:
%-- X     FFT of the signal
%-- freq  frequency vectors
%
% EXAMPLE:
%
%Fs = 50;
%t = (0:1/50:10)';
%x = [sin(2*pi*2*t)+0.5*cos(2*pi*3*t) 0.8*sin(2*pi*4*t)+0.5*cos(2*pi*7*t)];
%x = x+rand(size(x));
% figure(1);
% plot(t,x)
% xlabel('time (s)')
%
% [y,f] = easyFFT(x,Fs,true);
% figure(2);
% plot(f,abs(y));
% xlabel('freq (Hz)')

if size(signal,1)==1   % transpose the vector if the input is a row vector
    signal = signal.';
end

X = fft(signal);
N = size(signal,1);       %number of samples
delta_f=Fs/N;

if shiftFFT
    X=fftshift(X); % shift FFT
end

% build frequency vector
if shiftFFT
    if mod(N,2)==0
        k=-N/2:N/2-1; % N even
    else
        k=-(N-1)/2:(N-1)/2; % N odd
    end   
else
    k=0:N-1;
end

freq = k*delta_f;

end
