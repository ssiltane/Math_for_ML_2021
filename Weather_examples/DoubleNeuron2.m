% Simple double-neuron NN
%
% Arguments:
% x   mean temperature of a day (degrees Celsius)
% y   relative humidity (hPa)
%
% Returns:
% 0   for July day
% 1   for April day
%
% Samuli Siltanen Sep 2020

function res = DoubleNeuron2(x,y)

% First neuron
res = relu(y-.8*x+800);

% Second neuron
res = relu(-res+1);
