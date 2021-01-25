% Just one computational neuron
%
% Samuli Siltanen Jan 2021

function res = SingleNeuron(x,y)

% Neuron
res = relu(0.7071*x-0.7071*y);

