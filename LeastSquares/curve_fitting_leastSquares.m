% adjusts a curve to experimetal measurements.
%
% Fernando Moura Feb/2022

clear all;
close all;

%% First, let's sample points of a function f(x)  and store a list of pairs [ x_i, f(x_i) ]
% the function of choice is f(x)=cos(x)+noiseLevel*gaussian_white_noise.
% we will use these points to adjust a curve using the method of least squares
noiseLevel=0.1;
Npoints=100;
xi=linspace(0,2*pi,Npoints).';
fi=cos(xi)+noiseLevel*randn(size(xi));
%fi=log(xi+1)+sin(xi)+noiseLevel*randn(size(xi));

% plot sampled points from f(x)
figure(1);
set(gca,'fontsize',16);
plot(xi,fi,'k.');
xlabel('x_i');
ylabel('f(x_i)');
hold on;
grid on;
axis equal;

%% We will try to adjust a polinomial to the samples [ x_i, f(x_i) ]. For that we need 
% to choose a basis for the polinomial space. We will use a basis with vectors the form p_n(x)=x^n.
% lets start with the basis B0={x, x^2, x^3, x^4, x^5}. We will store p_n(x_i) in the columns of a matrix P
%
%        [     |     |     |     ]
%    B = [ p_1 | p_2 | ... | p_N ]
%        [     |     |     |     ] 

N_poly=[1, 2, 3, 4, 5];
B=zeros(Npoints,size(N_poly,2));
for n=N_poly
    %compute p_n(x_i)=x_i^n
    B(:,n)=xi.^n;
end

%% Now we can solve the problem using Generalized Least Squares (GLS).
%Inner product matrix (This matrix must be symmetric and positive definite!)
M=eye(size(xi,1));

% Generalized least equares solution
lambda=inv(B'*M*B)*B'*M*fi;


%% Vector lambda contains the coordinate vector of the polinomial space.
% the adjusted function will be
% f_adjusted(x) = lambda(1)*p1(x) + lambda(2)*p1(2)+ .... that best adjust
% to the samples  [ x_i, f(x_i) ]
%
% lets plot the adjuted function on top of the samples

NpointsAdjusted=1000;
x_vals = linspace(0,2*pi,NpointsAdjusted);

f_adjusted = zeros(1,NpointsAdjusted);
for n=N_poly
    %compute p_n(x_i)=x_i^n
    f_adjusted=f_adjusted+lambda(n)*x_vals.^n;
end

%% plot solution
plot(x_vals,f_adjusted,'r','LineWidth',2);

function_string=sprintf('f_p(x)=');
for n=N_poly
    function_string=sprintf('%s+(%1.3g)*x^%d',function_string,lambda(n),n);
end
text(0.1,2,sprintf(function_string),'fontsize',15,'Color','r');

legend('sampled data','adjusted function');

%% we see that the adjustment is not great near 0. The reason is that no
% vectors of the basis is nonzero at x=0, therefore there is no linear
% combination of x, x^2, x^3, x^4, x^5 that can generate a polynomial that
% has p(0) != 0!
% to fix that we must add a vector to the basis with that property. We need
% to add p(x)=const, for any nonzero constant. For example, we ca add p(x)=1

N_poly=[0, 1, 2, 3, 4, 5];
B=zeros(Npoints,size(N_poly,2));
for n=N_poly
    %compute p_n(x_i)=x_i^n
    B(:,n+1)=xi.^n;
end

%% Now we can solve the problem using Generalized Least Squares (GLS).

%Inner product matrix (This matrix must be symmetric and positive definite!)
M=eye(size(xi,1));

% Generalized least equares solution
lambda=inv(B'*M*B)*B'*M*fi;


%% Vector lambda contains the coordinate vector of the polinomial space.
% the adjusted function will be
% f_adjusted(x) = lambda(1)*p1(x) + lambda(2)*p1(2)+ .... that best adjust
% to the samples  [ x_i, f(x_i) ]
%
% lets plot the adjuted function on top of the samples

NpointsAdjusted=1000;
x_vals = linspace(0,2*pi,NpointsAdjusted);

f_adjusted = zeros(1,NpointsAdjusted);
for n=N_poly
    %compute p_n(x_i)=x_i^n
    f_adjusted=f_adjusted+lambda(n+1)*x_vals.^n;
end

%% plot solution
plot(x_vals,f_adjusted,'b','LineWidth',2);

function_string=sprintf('f_p(x)=');
for n=N_poly
    function_string=sprintf('%s+(%1.3g)*x^%d',function_string,lambda(n+1),n);
end
text(0.1,1.5,sprintf(function_string),'fontsize',15,'Color','b');

legend('sampled data','adjusted function');

