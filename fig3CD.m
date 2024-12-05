
% Beerendonk, Mejias et al. PNAS 2024
%
% Code for the computational model
%
% By Jorge Mejias, 2024


format short;clear all;
close all;clc;rng(938195);
Areas=1;Nareas=length(Areas);par=parameters(Areas);
bringparam(par);Iext=zeros(3,Nareas);Ipupil=Iext;Tpulse=1.5;mu0=0.013;


% Generate the psychometric and chronometric curves:
i=1;Cmin=0;Cstep=0.001;Cmax=0.2;Clength=length(Cmin:Cstep:Cmax);
Ntrials=300;performance=zeros(Clength,Ntrials);meanRT=performance;performanceF=performance;
for C=Cmin:Cstep:Cmax
    C
    for trials=1:Ntrials
        %for this contrast level:
        Iext(1,:)=mu0*(1+C);
        [rate,choice,RT]=trial(par,Iext,0.3,0.1,Nareas,Tpulse);
        %psychometric and chronometric output:
        z1=0;if choice==1 z1=1; end
        z2=0;if choice==0 z2=1; end
        performance(i,trials)=z1;
        performanceF(i,trials)=z2;
        meanRT(i,trials)=RT;
    end
    i=i+1;
end
performancem=mean(performance,2);
performancemF=mean(performanceF,2);
meanRTm=mean(meanRT,2);



%plot the result:
figure('Position',[450,650,700,600]);
subplot(2,2,1)
C=Cmin:Cstep:Cmax;
plot(C,performancem','LineWidth',2.0);xlabel('Coherence');ylabel('Performance (%)');hold on;
set(gca,'FontSize',12,'LineWidth',3,'TickLength',[0.01 0.01]);
set(gca,'box','off');ylim([0.4 1.1]);
subplot(2,2,2)
plot(C,meanRTm*1000,'LineWidth',2.0);xlabel('Coherence');ylabel('Mean RT (ms)');
set(gca,'FontSize',12,'LineWidth',3,'TickLength',[0.01 0.01]);set(gca,'box','off');
subplot(2,2,3)
C=Cmin:Cstep:Cmax;C2=[-flip(C) C];performanceF2=[1-flip(performancemF') performancemF'];
plot(C,performancem'-performancemF','LineWidth',2.0);xlabel('Coherence');ylabel('Hits - False hits (%)');hold on;
set(gca,'FontSize',12,'LineWidth',3,'TickLength',[0.01 0.01]);
set(gca,'box','off');ylim([-0.0 1.1]);



