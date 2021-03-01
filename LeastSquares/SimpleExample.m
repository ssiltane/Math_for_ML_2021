% Simple example of SVD related to learning
%
% Samuli Siltanen March 2021

%% Preliminaries

% We consider classifying the signals into "x-type" [1;0] and "y-type"
% [0;1] using a one-layer fully connected neural network model.
% Furthermore, our super-simple model has only a weight matrix 
% (no bias and no activation function). We write the 2x2 weight matrix as 
% W = [a,b;c,d] and aim for such training that W*x=[1;0] and W*y=[0;1].
% Here "training" simply means determining suitable values for a,b,c,d.
% In the following we denote f = [a;b] and g = [c;d]. We will do the
% training by least squares implemented explicitly with the singular value
% decomposition.

% Let's invent some data. Here the idea is that x,xp,y and yp are simplified 
% "FFT vectors of phone dial tones" in the sense that x-category vectors
% have a large first component and the second component close to zero. The
% y-category is the opposite: first element close to zero and second
% element large. This is of course a huge over-simplification compared to
% real data. 
x = [20;0.1];
xp = [30;0.2];
y = [0.15;100];
yp = [0.08;80];

% Build the system matrix. Here the data vectors appear as rows. 
A = [x.';xp.';y.';yp.'];



%% Solving for the first row of the weight matrix

% Construct the right hand side. We want to classify 
rhs = [1;1;0;0];

% Calculate singular value decomposition of A
[U,D,V] = svd(A);

% Solve the equation for the first row of the weight matrix in the least squares sense
svals = diag(D);
isvals = 1./svals;
Ddag = diag(isvals);
Ddag(2,4) = 0;
f = V*Ddag*U.'*rhs;



%% Solving for the second row of the weight matrix

% Construct the right hand side
rhs2 = [0;0;1;1];

% Solve the equation for the second row of the weight matrix in the least squares sense
g = V*Ddag*U.'*rhs2;



%% Construct and test the weight matrix
W = [f.';g.'];

% Test the weight matrix
W*x
W*xp
W*y
W*yp

