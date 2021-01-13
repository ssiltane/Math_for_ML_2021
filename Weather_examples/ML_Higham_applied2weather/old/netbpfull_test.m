function netbp_full
%NETBP_FULL
%   Extended version of netbp, with more graphics
%
%   Set up data for neural net test
%   Use backpropagation to train 
%   Visualize results
%
% C F Higham and D J Higham, Aug 2017
%
%%%%%%% DATA %%%%%%%%%%%
% xcoords, ycoords, targets
load  Highamdata  x1 x2 y x1MIN x1MAX x2MIN x2MAX Nweather
x1weather = x1;
x2weather = x2;
yweather = y;
% Nweather = 85;
% x1 = x1(1:Nweather);
% x2 = x2(1:Nweather);
% y = y(:,1:Nweather);
% Nweather = 40;
% x1 = [x1(1:20),x1(61:80)];
% x2 = [x2(1:20),x2(61:80)];
% y = [y(:,1:20),y(:,61:80)];
% Nweather = 60;
% x1 = [x1(1:30),x1(31:60)];
% x2 = [x2(1:30),x2(31:60)];
% y = [y(:,1:30),y(:,31:60)];
x1 = [0.1,0.3,0.1,0.6,0.4,0.6,0.5,0.9,0.4,0.7];
x2 = [0.1,0.4,0.5,0.9,0.2,0.3,0.6,0.2,0.4,0.6];
y = [ones(1,5) zeros(1,5); zeros(1,5) ones(1,5)];
Nweather = length(x1);
x1(1)  = x1weather(57);
x2(1)  = x2weather(57);
y(:,1) = yweather(:,57);
x1(2)  = x1weather(19);
x2(2)  = x2weather(19);
y(:,2) = yweather(:,19);
x1(3)  = x1weather(16);
x2(3)  = x2weather(16);
y(:,3) = yweather(:,16);
x1(4)  = x1weather(49);
x2(4)  = x2weather(49);
y(:,4) = yweather(:,49);
x1(5)  = x1weather(15);
x2(5)  = x2weather(15);
y(:,5) = yweather(:,15);
x1(6)  = x1weather(95);
x2(6)  = x2weather(95);
y(:,6) = yweather(:,95);
x1(7)  = x1weather(116);
x2(7)  = x2weather(116);
y(:,7) = yweather(:,116);
x1(8)  = x1weather(82);
x2(8)  = x2weather(82);
y(:,8) = yweather(:,82);
x1(9)  = x1weather(66);
x2(9)  = x2weather(66);
y(:,9) = yweather(:,66);
x1(10)  = x1weather(91);
x2(10)  = x2weather(91);
y(:,10) = yweather(:,91);

figure(1)
clf
a1 = subplot(1,1,1);
for iii = 1:Nweather
    if y(1,iii)>0
        plot(x1(iii),x2(iii),'ro','MarkerSize',12,'LineWidth',4)
        hold on
    else
        plot(x1(iii),x2(iii),'bx','MarkerSize',12,'LineWidth',4)
    end
end
a1.XTick = [0 1];
a1.YTick = [0 1];
a1.FontWeight = 'Bold';
a1.FontSize = 16;
xlim([0,1])
ylim([0,1])

%print -dpng pic_xy.png

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize weights and biases 
rng(5000);
W2 = 0.5*randn(2,2);
W3 = 0.5*randn(3,2);
W4 = 0.5*randn(2,3);
b2 = 0.5*randn(2,1);
b3 = 0.5*randn(3,1);
b4 = 0.5*randn(2,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Forward and Back propagate 
% Pick a training point at random
%eta = 0.05;
eta = 0.08;
Niter = 2000000;
savecost = zeros(Niter,1);
for counter = 1:Niter
    %k = randi(10);
    k = randi(Nweather);
    x = [x1(k); x2(k)];
    % Forward pass
    a2 = activate(x,W2,b2);
    a3 = activate(a2,W3,b3);
    a4 = activate(a3,W4,b4);
    % Backward pass
    delta4 = a4.*(1-a4).*(a4-y(:,k));
    delta3 = a3.*(1-a3).*(W4'*delta4);
    delta2 = a2.*(1-a2).*(W3'*delta3);
    % Gradient step
    W2 = W2 - eta*delta2*x';
    W3 = W3 - eta*delta3*a2';
    W4 = W4 - eta*delta4*a3';
    b2 = b2 - eta*delta2;
    b3 = b3 - eta*delta3;
    b4 = b4 - eta*delta4;
    % Monitor progress
    newcost = cost(W2,W3,W4,b2,b3,b4);
    savecost(counter) = newcost;
    if mod(counter,10000)==0
        disp([num2str(counter/Niter,'%0.2f'),'   ', num2str(newcost,'%f')])
    end
end

figure(2)
clf
semilogy([1:1e4:Niter],savecost(1:1e4:Niter),'b-','LineWidth',2)
xlabel('Iteration Number')
ylabel('Value of cost function')
set(gca,'FontWeight','Bold','FontSize',18)
print -dpng pic_cost.png

%%%%%%%%%%% Display shaded and unshaded regions 
N = 500;
Dx = 1/N;
Dy = 1/N;
xvals = [0:Dx:1];
yvals = [0:Dy:1];
for k1 = 1:N+1
    xk = xvals(k1);
    for k2 = 1:N+1
        yk = yvals(k2);
        xy = [xk;yk];
        a2 = activate(xy,W2,b2);
        a3 = activate(a2,W3,b3);
        a4 = activate(a3,W4,b4);
        Aval(k2,k1) = a4(1);
        Bval(k2,k1) = a4(2);
     end
end
[X,Y] = meshgrid(xvals,yvals);

figure(39)
mesh(X,Y,Aval)
axis square

figure(40)
mesh(X,Y,Bval)
axis square

figure(3)
clf
a2 = subplot(1,1,1);
Mval = Aval>Bval;
contourf(X,Y,Mval,[0.5 0.5])
hold on
colormap([1 1 1; 0.8 0.8 0.8])
for iii = 1:Nweather
    if y(1,iii)>0
        plot(x1(iii),x2(iii),'ro','MarkerSize',12,'LineWidth',4)
    else
        plot(x1(iii),x2(iii),'bx','MarkerSize',12,'LineWidth',4)
    end
    disp([x1(iii),x2(iii)])
end
a2.XTick = [0 1];
a2.YTick = [0 1];
a2.FontWeight = 'Bold';
a2.FontSize = 16;
xlim([0,1])
ylim([0,1])

print -dpng pic_bdy_bp.png

  function costval = cost(W2,W3,W4,b2,b3,b4)

     costvec = zeros(Nweather,1); 
     for i = 1:Nweather
         x =[x1(i);x2(i)];
         a2 = activate(x,W2,b2);
         a3 = activate(a2,W3,b3);
         a4 = activate(a3,W4,b4);
         costvec(i) = norm(y(:,i) - a4,2);
     end
     costval = norm(costvec,2)^2;
   end % of nested function

end
