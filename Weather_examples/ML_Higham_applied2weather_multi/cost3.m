function costval = cost3(W2,W3,W4,b2,b3,b4,Nweather,x1,x2,x3,y)

costvec = zeros(Nweather,1);
for i = 1:Nweather
    x =[x1(i);x2(i);x3(i)];
    a2 = activate(x,W2,b2);
    a3 = activate(a2,W3,b3);
    a4 = activate(a3,W4,b4);
    costvec(i) = norm(y(:,i) - a4,2);
end
costval = norm(costvec,2)^2;
end
