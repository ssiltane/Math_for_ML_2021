% Least-squares fit of a linear model 
% to a set of (simulated) measurement data.
%
% Samuli Siltanen March 2018

%% Parameters for plotting
lwidth = 2;
fsize = 20;
msize = 30;

%% Simulate some data. 
% First time instants, 
% then measurement values
t1 = 1;
t2 = 2;
t3 = 3;
t4 = 4;
t5 = 5;
t6 = 6;
t7 = 7;
tvec = [t1 t2 t3 t4 t5 t6 t7].';
m1 = .6;
m2 = .8;
m3 = 1.25;
m4 = 2.14;
m5 = 2.5;
m6 = 3.15;
m7 = 2.7;
mvec = [m1 m2 m3 m4 m5 m6 m7].';

% Plot the measurement
figure(1)
clf
plot(tvec,mvec,'r+','markersize',msize)
hold on
plot(tvec,mvec,'r.','markersize',msize)
axis equal

%% Let's construct the least-squares linear fit to the data
% We use the model m = a*t + b, where the real
% numbers a and b are our unknowns.
% Matrix equation: A*[a b].' = v

% Construct system matrix A
A = [...
    t1 1;...
    t2 1;...
    t3 1;...
    t4 1;...
    t5 1;...
    t6 1;...
    t7 1];

% Construct right-hand side vector v
v = mvec;

% Solve in the least squares sense
%result = A\v;
result = inv(A.'*A)*(A.'*v);
a = result(1);
b = result(2);

% Plot the linear model
tplot = linspace(t1,t7,5);
mplot = a*tplot+b;
plot(tplot,mplot,'b','linewidth',lwidth)