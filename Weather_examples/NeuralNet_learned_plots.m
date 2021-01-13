% Classify weather data from various months measured in Kumpula.
%
% Column 1: Cloud amount	1/8
% Column 2: Pressure (msl)	hPa
% Column 3: Relative humidity	%
% Column 4: Precipitation intensity	mm/h
% Column 5: Snow depth	cm
% Column 6: Air temperature	degC
% Column 7: Dew-point temperature	degC
% Column 8: Horizontal visibility	m
% Column 9: Wind direction	deg
% Column 10: Gust speed	m/s
% Column 11: Wind speed	m/s
%
% Samuli Siltanen January 2021

% Graphical parameters
color_summer = [200 0 0]/255;
color_summer_light = [245 226 226]/255;
color_fall   = [255 124 45]/255;
color_winter = [0 0 255]/255;
color_spring = [20 200 185]/255;
color_spring_light = [217 255 235]/255;
color_line = [.5 .5 .5];
gridline_color = [.7 .7 .7];
gridline_width = .5;
msize = 6;
msize2 = 8;
fsize = 26;
fsize2 = 12;
tickfsize = 16;
separ = .2;
lwidth = 1;
lwidth2 = .5;

% Interval between January and July temperatures
a = 6;
b = 8;

load data/weather2015 w04 w07
w04y15 = w04;
w07y15 = w07;

load data/weather2016 w01 w04 w07 w10
w01y16 = w01;
w04y16 = w04;
w07y16 = w07;
w10y16 = w10;

load data/weather2017 w01 w04 w07 w10
w01y17 = w01;
w04y17 = w04;
w07y17 = w07;
w10y17 = w10;

load data/weather2019 w01 w04 w07 w10
w01y19 = w01;
w04y19 = w04;
w07y19 = w07;
w10y19 = w10;


%% Picture 13, April and July temperatures for a hand-picked set of days

load NN_parameters W2 b2 W3 b3 W4 b4

% Prepare plots of neural network classification
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
[X,Y] = meshgrid(xvals,yvals); % Coordinates normalized to [0,1]^2
indexB2 = Aval>Bval;
indexB1 = Aval<Bval;

% "Un-normalized" coordinates and data for plotting
load ML_Higham_applied2weather/Highamdata x1 x2 y x1MIN x1MAX x2MIN x2MAX Nweather
Xplot = X*(x1MAX-x1MIN) + x1MIN;
Yplot = Y*(x2MAX-x2MIN) + x2MIN;
x1 = x1*(x1MAX-x1MIN) + x1MIN;
x2 = x2*(x2MAX-x2MIN) + x2MIN;


figure(13)
clf
p1 = plot(Xplot(indexB1),Yplot(indexB1),'bo','markersize',msize);
hold on
set(p1,'color',color_summer_light)
set(p1,'markerfacecolor',color_summer_light)
p1 = plot(Xplot(indexB2),Yplot(indexB2),'bo','markersize',msize);
set(p1,'color',color_spring_light)
set(p1,'markerfacecolor',color_spring_light)
rstep = 5;
rvec = [-5:rstep:30];
cstep = 10;
cvec = [990:cstep:1040];
for rrr = rvec
    p3 = plot([cvec(1)-cstep/5,cvec(end)+cstep/5],[rrr,rrr],'k','linewidth',gridline_width);
    hold on
    set(p3,'color',gridline_color)
    text(cvec(1)-.8*cstep,rrr,num2str(rrr,"%+3d"),'fontsize',fsize2)
end
for ccc = cvec
    p3 = plot([ccc,ccc],[rvec(1)-rstep/5,rvec(end)+rstep/5],'k','linewidth',gridline_width);
    set(p3,'color',gridline_color)
    text(ccc-.2*cstep,rvec(1)-.4*rstep,num2str(ccc,"%4d"),'fontsize',fsize2)
end
for iii = 1:Nweather
    if y(1,iii)<1
        p1 = plot(x1(iii),x2(iii),'bs','markersize',msize2);
        set(p1,'color',color_summer)
        set(p1,'markerfacecolor',color_summer)
    else
        p1 = plot(x1(iii),x2(iii),'bd','markersize',msize2);
        set(p1,'color',color_spring)
        set(p1,'markerfacecolor',color_spring)
    end
end
% One specialty plot for visibility of an outlier
p1 = plot(x1(57),x2(57),'bd','markersize',msize2);
set(p1,'color',color_spring)
set(p1,'markerfacecolor',color_spring)
%
title('Huhti- ja heinäkuun päivät 2015, 2016, 2017 ja 2019','fontsize',fsize2)
t3 = text(cvec(1)-1.3*cstep,rvec(1)+0.2*(rvec(end)-rvec(1)),'Päivän keskilämpötila (°C)','fontsize',fsize2);
set(t3,'rotation',90)
text(cvec(1)+0.3*(cvec(end)-cvec(1)),rvec(1)-1.2*rstep,'Ilmanpaine (hPa)','fontsize',fsize2)
% Axis settings
axis off
pbaspect([1.7 1 1])


%print -r400 -dpng images/FMIdata_13.png





%% Picture 14, April and July temperatures 

load NN_parameters W2 b2 W3 b3 W4 b4


% "Un-normalized" coordinates and data for plotting
load ML_Higham_applied2weather/Highamdata x1 x2 y x1MIN x1MAX x2MIN x2MAX
days_ind = [1,5,10,15,16,19,21,25,26,36,49,55,56,57,61,66,70,75,76,81,82,91,95,116,120,203,208];
Nweather = length(days_ind);
x1  = x1(days_ind);
x2  = x2(days_ind);
y   = y(:,days_ind);
x1 = x1*(x1MAX-x1MIN) + x1MIN;
x2 = x2*(x2MAX-x2MIN) + x2MIN;


figure(14)
clf
p1 = plot(Xplot(indexB1),Yplot(indexB1),'bo','markersize',msize);
hold on
set(p1,'color',color_summer_light)
set(p1,'markerfacecolor',color_summer_light)
p1 = plot(Xplot(indexB2),Yplot(indexB2),'bo','markersize',msize);
set(p1,'color',color_spring_light)
set(p1,'markerfacecolor',color_spring_light)
rstep = 5;
rvec = [-5:rstep:30];
cstep = 10;
cvec = [990:cstep:1040];
for rrr = rvec
    p3 = plot([cvec(1)-cstep/5,cvec(end)+cstep/5],[rrr,rrr],'k','linewidth',gridline_width);
    hold on
    set(p3,'color',gridline_color)
    text(cvec(1)-.8*cstep,rrr,num2str(rrr,"%+3d"),'fontsize',fsize2)
end
for ccc = cvec
    p3 = plot([ccc,ccc],[rvec(1)-rstep/5,rvec(end)+rstep/5],'k','linewidth',gridline_width);
    set(p3,'color',gridline_color)
    text(ccc-.2*cstep,rvec(1)-.4*rstep,num2str(ccc,"%4d"),'fontsize',fsize2)
end
for iii = 1:Nweather
    if y(1,iii)<1
        p1 = plot(x1(iii),x2(iii),'bs','markersize',msize2);
        set(p1,'color',color_summer)
        set(p1,'markerfacecolor',color_summer)
    else
        p1 = plot(x1(iii),x2(iii),'bd','markersize',msize2);
        set(p1,'color',color_spring)
        set(p1,'markerfacecolor',color_spring)
    end
end
%
title('Valikoima huhti- ja heinäkuun päiviä 2015-2019','fontsize',fsize2)
t3 = text(cvec(1)-1.3*cstep,rvec(1)+0.2*(rvec(end)-rvec(1)),'Päivän keskilämpötila (°C)','fontsize',fsize2);
set(t3,'rotation',90)
text(cvec(1)+0.3*(cvec(end)-cvec(1)),rvec(1)-1.2*rstep,'Ilmanpaine (hPa)','fontsize',fsize2)
% Axis settings
axis off
pbaspect([1.7 1 1])


%print -r400 -dpng images/FMIdata_14.png





%% Picture 15, April and July temperatures for two specific days in 2019


figure(15)

clf
day04_ind = 7;
p1 = plot(w04y19(day04_ind,2),w04y19(day04_ind,6),'bs','markersize',msize);
hold on
set(p1,'color',color_spring)
set(p1,'markerfacecolor',color_spring)
p2 = plot([w04y19(day04_ind,2),w04y19(day04_ind,2)],[-30,w04y19(day04_ind,6)],'k','linewidth',lwidth2);
set(p2,'color',color_spring)
p2 = plot([0,w04y19(day04_ind,2)],[w04y19(day04_ind,6),w04y19(day04_ind,6)],'k','linewidth',lwidth2);
set(p2,'color',color_spring)
t1 = text(1012,8,'8.4.2019','fontsize',fsize);
set(t1,'color',color_spring)
%
day07_ind = 1;
p1 = plot(w07y19(day07_ind,2),w07y19(day07_ind,6),'bd','markersize',msize);
set(p1,'color',color_summer)
set(p1,'markerfacecolor',color_summer)
p2 = plot([w07y19(day07_ind,2),w07y19(day07_ind,2)],[-30,w07y19(day07_ind,6)],'k','linewidth',lwidth2);
set(p2,'color',color_summer)
p2 = plot([0,w07y19(day07_ind,2)],[w07y19(day07_ind,6),w07y19(day07_ind,6)],'k','linewidth',lwidth2);
set(p2,'color',color_summer)
t1 = text(996,21,'1.7.2019','fontsize',fsize);
set(t1,'color',color_summer)
%
title('Ilmatieteen laitos: Kumpula 2019','fontsize',fsize)
ylabel('Päivän keskilämpötila (°C)','fontsize',fsize)
xlabel('Ilmanpaine (hPa)','fontsize',fsize)
set(gca,'xtick',[990:10:1040],'fontsize',tickfsize)
set(gca,'ytick',[-40:5:30],'fontsize',tickfsize)
axis([990 1040 -10 30])






%print -r400 -dpng images/FMIdata_15.png








%% Picture 16, April and July temperatures for a hand-picked set of days

load NN_parameters W2 b2 W3 b3 W4 b4


% "Un-normalized" coordinates and data for plotting
load ML_Higham_applied2weather/Highamdata x1 x2 y x1MIN x1MAX x2MIN x2MAX
days_ind = [1,5,10,15,16,19,21,25,26,36,49,55,56,57,61,66,70,75,76,81,82,91,95,116,120,203,208];
Nweather = length(days_ind);
x1  = x1(days_ind);
x2  = x2(days_ind);
y   = y(:,days_ind);
x1 = x1*(x1MAX-x1MIN) + x1MIN;
x2 = x2*(x2MAX-x2MIN) + x2MIN;


figure(16)
clf
% p1 = plot(Xplot(indexB1),Yplot(indexB1),'bo','markersize',msize);
% hold on
% set(p1,'color',color_summer_light)
% set(p1,'markerfacecolor',color_summer_light)
% p1 = plot(Xplot(indexB2),Yplot(indexB2),'bo','markersize',msize);
% set(p1,'color',color_spring_light)
% set(p1,'markerfacecolor',color_spring_light)
rstep = 5;
rvec = [-5:rstep:30];
cstep = 10;
cvec = [990:cstep:1040];
for rrr = rvec
    p3 = plot([cvec(1)-cstep/5,cvec(end)+cstep/5],[rrr,rrr],'k','linewidth',gridline_width);
    hold on
    set(p3,'color',gridline_color)
    text(cvec(1)-.8*cstep,rrr,num2str(rrr,"%+3d"),'fontsize',fsize2)
end
for ccc = cvec
    p3 = plot([ccc,ccc],[rvec(1)-rstep/5,rvec(end)+rstep/5],'k','linewidth',gridline_width);
    set(p3,'color',gridline_color)
    text(ccc-.2*cstep,rvec(1)-.4*rstep,num2str(ccc,"%4d"),'fontsize',fsize2)
end
for iii = [4,24]
    if y(1,iii)<1
        if iii==24 % July 26, 2019
            p2 = plot([x1(iii),x1(iii)],[-5,x2(iii)],'k','linewidth',lwidth2);
            set(p2,'color',color_summer)
            p2 = plot([990,x1(iii)],[x2(iii),x2(iii)],'k','linewidth',lwidth2);
            set(p2,'color',color_summer)
            t1 = text(x1(iii)+1,x2(iii)+2,'26.7.2019','fontsize',fsize);
            set(t1,'color',color_summer)
            disp(['July 26, 2019: ',num2str(x1(iii)),' hPa, ',num2str(x2(iii)),' °C'])
        end
        p1 = plot(x1(iii),x2(iii),'bs','markersize',msize2);
        set(p1,'color',color_summer)
        set(p1,'markerfacecolor',color_summer)
    else
        if iii==4 % Weather on April 15, 2017
            p2 = plot([x1(iii),x1(iii)],[-5,x2(iii)],'k','linewidth',lwidth2);
            set(p2,'color',color_spring)
            p2 = plot([990,x1(iii)],[x2(iii),x2(iii)],'k','linewidth',lwidth2);
            set(p2,'color',color_spring)
            t1 = text(x1(iii)-8,x2(iii)+4,'15.4.2017','fontsize',fsize);
            set(t1,'color',color_spring)
            disp(['April 15, 2017: ',num2str(x1(iii)),' hPa, ',num2str(x2(iii)),' °C'])
        end
        p1 = plot(x1(iii),x2(iii),'bd','markersize',msize2);
        set(p1,'color',color_spring)
        set(p1,'markerfacecolor',color_spring)
    end
end
%
title('','fontsize',fsize2)
t3 = text(cvec(1)-1.3*cstep,rvec(1)+0.2*(rvec(end)-rvec(1)),'Päivän keskilämpötila (°C)','fontsize',fsize2);
set(t3,'rotation',90)
text(cvec(1)+0.3*(cvec(end)-cvec(1)),rvec(1)-1.2*rstep,'Ilmanpaine (hPa)','fontsize',fsize2)
% Axis settings
axis off
pbaspect([1.7 1 1])


%print -r400 -dpng images/FMIdata_16.png




%% Picture 17, April and July temperatures 

load NN_parameters W2 b2 W3 b3 W4 b4

disp(W2)
disp(b2)

disp(W3)
disp(b3)

disp(W4)
disp(b4)

% Prepare plots of neural network classification
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
[X,Y] = meshgrid(xvals,yvals); % Coordinates normalized to [0,1]^2
indexB2 = Aval>Bval;
indexB1 = Aval<Bval;

% "Un-normalized" coordinates and data for plotting
load ML_Higham_applied2weather/Highamdata x1 x2 y x1MIN x1MAX x2MIN x2MAX Nweather
Xplot = X*(x1MAX-x1MIN) + x1MIN;
Yplot = Y*(x2MAX-x2MIN) + x2MIN;
x1 = x1*(x1MAX-x1MIN) + x1MIN;
x2 = x2*(x2MAX-x2MIN) + x2MIN;


figure(17)
clf
p1 = plot(Xplot(indexB1),Yplot(indexB1),'bo','markersize',msize);
hold on
set(p1,'color',color_summer_light)
set(p1,'markerfacecolor',color_summer_light)
p1 = plot(Xplot(indexB2),Yplot(indexB2),'bo','markersize',msize);
set(p1,'color',color_spring_light)
set(p1,'markerfacecolor',color_spring_light)
rstep = 5;
rvec = [-5:rstep:30];
cstep = 10;
cvec = [990:cstep:1040];
for rrr = rvec
    p3 = plot([cvec(1)-cstep/5,cvec(end)+cstep/5],[rrr,rrr],'k','linewidth',gridline_width);
    hold on
    set(p3,'color',gridline_color)
    text(cvec(1)-.8*cstep,rrr,num2str(rrr,"%+3d"),'fontsize',fsize2)
end
for ccc = cvec
    p3 = plot([ccc,ccc],[rvec(1)-rstep/5,rvec(end)+rstep/5],'k','linewidth',gridline_width);
    set(p3,'color',gridline_color)
    text(ccc-.2*cstep,rvec(1)-.4*rstep,num2str(ccc,"%4d"),'fontsize',fsize2)
end
for iii = 1:Nweather
    if y(1,iii)<1
        p1 = plot(x1(iii),x2(iii),'bs','markersize',msize2);
        set(p1,'color',color_summer)
        set(p1,'markerfacecolor',color_summer)
    else
        p1 = plot(x1(iii),x2(iii),'bd','markersize',msize2);
        set(p1,'color',color_spring)
        set(p1,'markerfacecolor',color_spring)
    end
end
% One specialty plot for visibility of an outlier
p1 = plot(x1(57),x2(57),'bd','markersize',msize2);
set(p1,'color',color_spring)
set(p1,'markerfacecolor',color_spring)
%
title('Huhti- ja heinäkuun päivät 2015, 2016, 2017 ja 2019','fontsize',fsize2)
t3 = text(cvec(1)-1.3*cstep,rvec(1)+0.2*(rvec(end)-rvec(1)),'Päivän keskilämpötila (°C)','fontsize',fsize2);
set(t3,'rotation',90)
text(cvec(1)+0.3*(cvec(end)-cvec(1)),rvec(1)-1.2*rstep,'Ilmanpaine (hPa)','fontsize',fsize2)
% Axis settings
axis off
pbaspect([1.7 1 1])


%print -r400 -dpng images/FMIdata_17.png




%% Picture 18, April and July temperatures for a hand-picked set of days

load NN_parameters2 W2 b2 W3 b3 W4 b4


% "Un-normalized" coordinates and data for plotting
load ML_Higham_applied2weather/Highamdata x1 x2 y x1MIN x1MAX x2MIN x2MAX
days_ind = [1,3,5,7,10,12,15,16,19,21,25,26,36,49,55,56,57,61,66,70,75,76,81,82,91,95,100,101,102,116,120,203,208];
Nweather = length(days_ind);
x1  = x1(days_ind);
x2  = x2(days_ind);
y   = y(:,days_ind);
x1 = x1*(x1MAX-x1MIN) + x1MIN;
x2 = x2*(x2MAX-x2MIN) + x2MIN;


figure(18)
clf
p1 = plot(Xplot(indexB1),Yplot(indexB1),'bo','markersize',msize);
hold on
set(p1,'color',color_summer_light)
set(p1,'markerfacecolor',color_summer_light)
p1 = plot(Xplot(indexB2),Yplot(indexB2),'bo','markersize',msize);
set(p1,'color',color_spring_light)
set(p1,'markerfacecolor',color_spring_light)
rstep = 5;
rvec = [-5:rstep:30];
cstep = 10;
cvec = [990:cstep:1040];
for rrr = rvec
    p3 = plot([cvec(1)-cstep/5,cvec(end)+cstep/5],[rrr,rrr],'k','linewidth',gridline_width);
    hold on
    set(p3,'color',gridline_color)
    text(cvec(1)-.8*cstep,rrr,num2str(rrr,"%+3d"),'fontsize',fsize2)
end
for ccc = cvec
    p3 = plot([ccc,ccc],[rvec(1)-rstep/5,rvec(end)+rstep/5],'k','linewidth',gridline_width);
    set(p3,'color',gridline_color)
    text(ccc-.2*cstep,rvec(1)-.4*rstep,num2str(ccc,"%4d"),'fontsize',fsize2)
end
for iii = 1:Nweather
    if y(1,iii)<1
        p1 = plot(x1(iii),x2(iii),'bs','markersize',msize2);
        set(p1,'color',color_summer)
        set(p1,'markerfacecolor',color_summer)
    else
        p1 = plot(x1(iii),x2(iii),'bd','markersize',msize2);
        set(p1,'color',color_spring)
        set(p1,'markerfacecolor',color_spring)
    end
end
%
title('Valikoima huhti- ja heinäkuun päiviä 2015-2019','fontsize',fsize2)
t3 = text(cvec(1)-1.3*cstep,rvec(1)+0.2*(rvec(end)-rvec(1)),'Päivän keskilämpötila (°C)','fontsize',fsize2);
set(t3,'rotation',90)
text(cvec(1)+0.3*(cvec(end)-cvec(1)),rvec(1)-1.2*rstep,'Ilmanpaine (hPa)','fontsize',fsize2)
% Axis settings
axis off
pbaspect([1.7 1 1])


%print -r400 -dpng images/FMIdata_18.png


