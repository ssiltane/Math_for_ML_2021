% ReLU activation function implementation
%
% Siiri Rautio

function y = sigmoid(x)

y = 1./(1+exp(-x)); 

