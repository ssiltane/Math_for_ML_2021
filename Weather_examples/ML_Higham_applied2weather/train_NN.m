function train_NN
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
days_ind = [1,5,10,15,16,19,21,25,26,36,49,55,56,57,61,66,70,75,76,81,82,91,95,116,120,203,208];
Nweather = length(days_ind);
x1  = x1(days_ind);
x2  = x2(days_ind);
y   = y(:,days_ind);

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
W2 = 0.7*randn(2,2);
W3 = 0.7*randn(3,2);
W4 = 0.7*randn(2,3);
b2 = 0.7*randn(2,1);
b3 = 0.7*randn(3,1);
b4 = 0.7*randn(2,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Forward and Back propagate
% Pick a training point at random
%eta = 0.05;
eta = 0.03;
Niter = 5000000;
tic
savecost = zeros(Niter,1);
for counter = 1:Niter
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
    if mod(counter,100000)==0
        disp([num2str(counter/Niter,'%0.2f'),'   ', num2str(newcost,'%f')])
        
        %%%%%%%%%%% Display shaded and unshaded regions
        N = 100;
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
        end
        a2.XTick = [0 1];
        a2.YTick = [0 1];
        a2.FontWeight = 'Bold';
        a2.FontSize = 16;
        xlim([0,1])
        ylim([0,1])
    end
end

disp(toc)

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

save NN_parameters W2 b2 W3 b3 W4 b4

% figure(39)
% mesh(X,Y,Aval)
% axis square
%
% figure(40)
% mesh(X,Y,Bval)
% axis square

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
