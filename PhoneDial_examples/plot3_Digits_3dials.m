% plot digit data using the digits as markers
% allDigitData is a 3D tensor
%       dim1: x,y,z data
%       dim2: samples
%       dim3: digit
% colors:
%
%  Fernando moura Feb/2022

function plot3_Digits_3dials(figHandle,allDigitData)

% color definition
colors=[[1 0 0];
    [0 1 0];
    [1 0 1];
    [0 0 0];
    [0 0.5 0];
    [0 0.5 1];
    [.5 .5 .5];
    [.1 .5 .1];
    [.3 .1 .8];
    [.6 .1 .1]];

figure(figHandle)
clf
hold on
K=size(allDigitData,2);
for digit =1:3
    digitData=allDigitData(:,:,digit);
    for k=1:K
        x=digitData(1,k);
        y=digitData(2,k);
        z=digitData(3,k);
        % matlab does not allow plotting characters as markers so we have
        % to add text instead.
        text(x,y,z,num2str(mod(digit,10)),'Color',colors(digit,:),'FontSize',15);
    end
end
minData=min(allDigitData,[],[2,3]);
maxData=max(allDigitData,[],[2,3]);
xlim([minData(1),maxData(1)]);
ylim([minData(2),maxData(2)]);
zlim([minData(3),maxData(3)]);
axis square

view([-45 30])
hold off