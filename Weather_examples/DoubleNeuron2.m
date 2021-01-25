% Simple double-neuron NN
%
% Arguments:
% x   mean air pressure of a day (hPa)
% y   mean temperature of a day (degrees Celsius)
%
% Returns:
% 0   for July day
% 1   for April day
%
% Samuli Siltanen Jan 2021

function res = DoubleNeuron2(x,y)

% First neuron
res = relu(y-.8*x+800);

% Second neuron
res = relu(-res+1);
