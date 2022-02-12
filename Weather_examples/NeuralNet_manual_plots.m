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

%% Picture 1: January and July temperatures

figure(1)
clf
len = length(w01y19(:,6));
p1 = plot(ones(1,len)+separ*[0:(len-1)]/len,w01y19(:,6),'bo','markersize',msize);
hold on
set(p1,'color',color_winter)
set(p1,'markerfacecolor',color_winter)
t1 = text(1.5,-15,'January','fontsize',fsize);
set(t1,'color',color_winter)
%
len = length(w07y19(:,6));
p1 = plot(3*ones(1,len)+separ*[0:(len-1)]/len,w07y19(:,6),'bd','markersize',msize);
set(p1,'color',color_summer)
set(p1,'markerfacecolor',color_summer)
t1 = text(3.4,max(w07y19(:,6)),'July','fontsize',fsize);
set(t1,'color',color_summer)
%
axis([0 6 -20 30])
title('weather Institute: Kumpula 2019','fontsize',fsize)
ylabel('Avg. daily temp. (°C)','fontsize',fsize)
set(gca,'xtick','')
set(gca,'ytick',[-25:5:30],'fontsize',tickfsize)

%print -r400 -dpng images/FMIdata_01.png









%% Picture 6, April and July temperatures and humidities in 2019


figure(6)
clf
len = length(w04(:,6));
p1 = plot(w04y19(:,3),w04y19(:,6),'bs','markersize',msize);
hold on
set(p1,'color',color_spring)
set(p1,'markerfacecolor',color_spring)
t1 = text(70,-6,'April','fontsize',fsize);
set(t1,'color',color_spring)
%
len = length(w07y19(:,6));
p1 = plot(w07y19(:,3),w07y19(:,6),'bd','markersize',msize);
set(p1,'color',color_summer)
set(p1,'markerfacecolor',color_summer)
t1 = text(80,25,'July','fontsize',fsize);
set(t1,'color',color_summer)
%
title('weather Institute: Kumpula 2019','fontsize',fsize)
ylabel('Avg. daily temp. (°C)','fontsize',fsize)
xlabel('Relative humidity (%)','fontsize',fsize)
set(gca,'xtick',[0:10:100],'fontsize',tickfsize)
set(gca,'ytick',[-40:5:30],'fontsize',tickfsize)
axis([30 100 -10 30])

%print -r400 -dpng images/FMIdata_06.png



%% Picture 7, April and July temperatures and air pressures in 2019

figure(7)
clf
len = length(w04y19(:,6));
p1 = plot(w04y19(:,2),w04y19(:,6),'bs','markersize',msize);
hold on
set(p1,'color',color_spring)
set(p1,'markerfacecolor',color_spring)
t1 = text(1010,-6,'April','fontsize',fsize);
set(t1,'color',color_spring)
%
len = length(w07y19(:,6));
p1 = plot(w07y19(:,2),w07y19(:,6),'bd','markersize',msize);
set(p1,'color',color_summer)
set(p1,'markerfacecolor',color_summer)
t1 = text(995,25,'July','fontsize',fsize);
set(t1,'color',color_summer)
%
title('weather Institute: Kumpula 2019','fontsize',fsize)
ylabel('Avg. daily temp. (°C)','fontsize',fsize)
xlabel('Atm. pressure (hPa)','fontsize',fsize)
set(gca,'xtick',[990:10:1040],'fontsize',tickfsize)
set(gca,'ytick',[-40:5:30],'fontsize',tickfsize)
axis([990 1040 -10 30])

%print -r400 -dpng images/FMIdata_07.png



%% Picture 8, April and July temperatures and air pressures in 2019 with division lines

figure(8)
clf
len = length(w04y19(:,6));
p1 = plot(w04y19(:,2),w04y19(:,6),'bs','markersize',msize);
hold on
set(p1,'color',color_spring)
set(p1,'markerfacecolor',color_spring)
t1 = text(1010,-6,'April','fontsize',fsize);
set(t1,'color',color_spring)
%
len = length(w07y19(:,6));
p1 = plot(w07y19(:,2),w07y19(:,6),'bd','markersize',msize);
set(p1,'color',color_summer)
set(p1,'markerfacecolor',color_summer)
t1 = text(995,25,'July','fontsize',fsize);
set(t1,'color',color_summer)
%
% Plot line providing approximate classification
% A good line is y = 0.8x-800
p2 = plot([990 1040],0.8*[990 1040]-800,'k','linewidth',lwidth);
set(p2,'color',color_line)
% p2 = plot([990 1040],0.8*[990 1040]-798,'k','linewidth',lwidth);
% set(p2,'color',color_line)
t3 = text(1024,17,' y = 0.8x-800','fontsize',fsize);
set(t3,'rotation',360*atan(.8)/(2*pi))
% t3 = text(991,-3,' y = 0.8x-798','fontsize',fsize);
% set(t3,'rotation',360*atan(.8)/(2*pi))
%
title('weather Institute: Kumpula 2019','fontsize',fsize)
ylabel('Avg. daily temp. (°C)','fontsize',fsize)
xlabel('Atm. pressure (hPa)','fontsize',fsize)
set(gca,'xtick',[990:10:1040],'fontsize',tickfsize)
set(gca,'ytick',[-40:5:30],'fontsize',tickfsize)
axis([990 1040 -10 30])

%print -r400 -dpng images/FMIdata_08.png









%% Picture 9, April and July temperatures and air pressures in 2019


xvec = linspace(990,1040,200);
yvec = linspace(-10,30,200);
[X,Y] = meshgrid(xvec,yvec);
index1 = DoubleNeuron2(X,Y)>0.99;
index2 = DoubleNeuron2(X,Y)<0.01;

figure(9)
clf
p1 = plot(X(index1),Y(index1),'bo','markersize',msize);
hold on
set(p1,'color',color_spring_light)
set(p1,'markerfacecolor',color_spring_light)
p1 = plot(X(index2),Y(index2),'bo','markersize',msize);
set(p1,'color',color_summer_light)
set(p1,'markerfacecolor',color_summer_light)
%
rstep = 5;
rvec = [-10:rstep:30];
cstep = 10;
cvec = [990:cstep:1040];
for rrr = rvec
    p3 = plot([cvec(1)-cstep/5,cvec(end)+cstep/5],[rrr,rrr],'k','linewidth',gridline_width);
    set(p3,'color',gridline_color)
    text(cvec(1)-.8*cstep,rrr,num2str(rrr,"%+3d"),'fontsize',fsize2)
end
for ccc = cvec
    p3 = plot([ccc,ccc],[rvec(1)-rstep/5,rvec(end)+rstep/5],'k','linewidth',gridline_width);
    set(p3,'color',gridline_color)
    text(ccc-.2*cstep,rvec(1)-.4*rstep,num2str(ccc,"%4d"),'fontsize',fsize2)
end
%
len = length(w04y19(:,6));
p1 = plot(w04y19(:,2),w04y19(:,6),'bs','markersize',msize2);
set(p1,'color',color_spring)
set(p1,'markerfacecolor',color_spring)
t1 = text(1010,-6,'April','fontsize',fsize2);
set(t1,'color',color_spring)
%
len = length(w07y19(:,6));
p1 = plot(w07y19(:,2),w07y19(:,6),'bd','markersize',msize2);
set(p1,'color',color_summer)
set(p1,'markerfacecolor',color_summer)
t1 = text(995,25,'July','fontsize',fsize2);
set(t1,'color',color_summer)
%
title('weather Institute: Kumpula 2019','fontsize',fsize2)
t3 = text(cvec(1)-1.3*cstep,rvec(1)+0.2*(rvec(end)-rvec(1)),'Avg. daily temp. (°C)','fontsize',fsize2);
set(t3,'rotation',90)
text(cvec(1)+0.3*(cvec(end)-cvec(1)),rvec(1)-1.2*rstep,'Atm. pressure (hPa)','fontsize',fsize2)
axis off
pbaspect([1.7 1 1])

%print -r400 -dpng images/FMIdata_09.png


%% Picture 10, April and July temperatures and air pressures in 2017


figure(10)
clf
p1 = plot(X(index1),Y(index1),'bo','markersize',msize);
hold on
set(p1,'color',color_spring_light)
set(p1,'markerfacecolor',color_spring_light)
p1 = plot(X(index2),Y(index2),'bo','markersize',msize);
set(p1,'color',color_summer_light)
set(p1,'markerfacecolor',color_summer_light)
%
rstep = 5;
rvec = [-10:rstep:30];
cstep = 10;
cvec = [990:cstep:1040];
for rrr = rvec
    p3 = plot([cvec(1)-cstep/5,cvec(end)+cstep/5],[rrr,rrr],'k','linewidth',gridline_width);
    set(p3,'color',gridline_color)
    text(cvec(1)-.8*cstep,rrr,num2str(rrr,"%+3d"),'fontsize',fsize2)
end
for ccc = cvec
    p3 = plot([ccc,ccc],[rvec(1)-rstep/5,rvec(end)+rstep/5],'k','linewidth',gridline_width);
    set(p3,'color',gridline_color)
    text(ccc-.2*cstep,rvec(1)-.4*rstep,num2str(ccc,"%4d"),'fontsize',fsize2)
end
%
%
len = length(w04y17(:,6));
p1 = plot(w04y17(:,2),w04y17(:,6),'bs','markersize',msize2);
set(p1,'color',color_spring)
set(p1,'markerfacecolor',color_spring)
t1 = text(1010,-6,'April','fontsize',fsize2);
set(t1,'color',color_spring)
%
len = length(w07y17(:,6));
p1 = plot(w07y17(:,2),w07y17(:,6),'bd','markersize',msize2);
set(p1,'color',color_summer)
set(p1,'markerfacecolor',color_summer)
t1 = text(995,25,'July','fontsize',fsize2);
set(t1,'color',color_summer)
%
title('weather Institute: Kumpula 2017','fontsize',fsize2)
t3 = text(cvec(1)-1.3*cstep,rvec(1)+0.2*(rvec(end)-rvec(1)),'Avg. daily temp. (°C)','fontsize',fsize2);
set(t3,'rotation',90)
text(cvec(1)+0.3*(cvec(end)-cvec(1)),rvec(1)-1.2*rstep,'Atm. pressure (hPa)','fontsize',fsize2)
axis off
pbaspect([1.7 1 1])

%print -r400 -dpng images/FMIdata_10.png




