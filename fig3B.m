
% Beerendonk, Mejias et al. PNAS 2024
%
% Code for the computational model
%
% By Jorge Mejias, 2024


format short;clear all;
close all;clc;rng(938195);
Areas=1;Nareas=length(Areas);par=parameters(Areas);
bringparam(par);Iext=zeros(3,Nareas);Ipupil=Iext;Tpulse=1.5;mu0=0.013;

% single trial run:
C=0.02;Iext(1,:)=mu0*(1+C); %sensory input with contrast C
[rate,choice,RT]=trial(par,Iext,0.3,0.1,Nareas,Tpulse);
choice, RT


%we plot the result:
figure('Position',[750,450,350,280]);hold on;
blue1=[.1 .6 .8];purple1=[.6 0 .5];
Tmin=dt;Tmax=triallength;dt2=5;
r1=rate(1,Tmin/dt:Tmax/dt,1);
r2=rate(2,Tmin/dt:Tmax/dt,1);
r3=rate(3,Tmin/dt:Tmax/dt,1);
time=Tmin:dt:Tmax;
plot(time(1:dt2:end)-2,r1(1:dt2:end),'Color',blue1,'LineWidth',2.0);hold on;
plot(time(1:dt2:end)-2,r2(1:dt2:end),'Color',purple1,'LineWidth',2.0);hold on;
yline(threshold,'--');
set(gca,'FontSize',12,'LineWidth',3,'TickLength',[0.01 0.01])


maxi=1.3*max([r1(1000:end) r2(1000:end)]);
topyaxis=max(maxi,2);topyaxis=max(topyaxis,20);
ylim([-5 topyaxis]);ylim([-2 25]);
topxaxis=par.triallength;
xlim([0 topxaxis]);xlim([0 1]);
format short g;
set(gca,'box','off');
ylabel('Rate (sp/s)');
xlabel('Time (s)');



