function output = singleNeuron(x1,x2)
% inputs x1, x2 
    
    w1 = 0.7071;
    w2 = -0.7071;
    bias  = 0;
    
    output = relu(w1*x1 + w2*x2 + bias);
end

