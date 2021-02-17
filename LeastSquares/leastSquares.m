clear all;
close all;

%% create sample points xi, f(xi)
% the function is f(x)=cos(x)+noiseLevel*gaussian_white_noise
noiseLevel=0.1;
xi=[0:0.05:2*pi]';
fi=cos(xi)+noiseLevel*randn(size(xi));

% plot original function
figure(1);
set(gca,'fontsize',16);
plot(xi,fi,'k.');
xlabel('x_i');
ylabel('f(x_i)');
hold on;
grid on;
axis equal;

%% Create basis (polinomials p_n(x)={x^1,x^2,x^3,....x^N})
%  Constant function p(x)=1 is optional
N=5;
%add p(x)=1?
Add_constant=0;

P=[];
if Add_constant==1
    %add the function f(x)=1 outside for loop
    P=[ones(size(xi))];
end

for n=1:N
    %compute p_n(x_i)=x_i^n
    basisPoints=xi.^n;
    P=[P basisPoints];
end

%% Generalized Least Squares (GLS)
%find Lambda Vector using Generalized Least Squares

%Inner product matrix
M=eye(size(xi,1)); %This must be symmetric and positive definite!

%GLS
lambda_vector=inv(P'*M*P)*P'*M*fi;

adjusted_function=P*lambda_vector;


%% plot solution
plot(xi,adjusted_function,'r');

% show the adjusted expression
if Add_constant==1
    function_string=sprintf('f_p(x)=(%1.3g)*1',lambda_vector(1));
    for n=1:N
        function_string=sprintf('%s+(%1.3g)*x^%d',function_string,lambda_vector(n+1),n);
    end
else
    function_string=sprintf('f_p(x)=');
    for n=1:N
        function_string=sprintf('%s+(%1.3g)*x^%d',function_string,lambda_vector(n),n);
    end
end

text(1,2,sprintf(function_string),'fontsize',15);
legend('original Data','adjusted function');


