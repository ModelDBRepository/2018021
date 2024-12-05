
% Beerendonk, Mejias et al. PNAS 2024
%
% Code for the computational model
%
% By Jorge Mejias, 2024


format short;clear all;
close all;clc;rng(938196);
Areas=1;Nareas=length(Areas);par=parameters(Areas);
bringparam(par);Iext=zeros(3,Nareas);Ipupil=Iext;Tpulse=1.5;mu0=0.013;

%set up the slowly evolvind arousal signal across trials:
arousalmean=0.4;arousalstd=0.2;tauar=20;sessiondt=2;
sessionlength=200;Ntrials=round(sessionlength/sessiondt);
xi2=normrnd(0,1,round(sessionlength/sessiondt));arousal=zeros(round(sessionlength/sessiondt),1);hit=arousal;
tstep3=sessiondt/tauar;tstep4=arousalstd*(sessiondt/tauar)^(0.5);

i=2;hit(1)=-1;arousal(1)=arousalmean;
for trials=2:Ntrials
    
    %arousal signal (Ornstein-Uhlenbeck noise):
    arousal(i,1)=arousal(i-1,1)+tstep3*(arousalmean-arousal(i-1,1))+tstep4*xi2(i-1);
    Ipupil=arousal(i,1);

    % single trial:
    C=0.02;neurom=0.1;
    Iext(1,:)=mu0*(1+C);
    [rate,choice,RT]=trial(par,Iext,Ipupil,neurom,Nareas,Tpulse);
    if choice==1
        hit(i,1)=0.05;
    else
        hit(i,1)=-1;
    end

    i=i+1;
end


%plot the whole session:
hitcolor=[.1 .3 .8];
timesession=(sessiondt:sessiondt:sessionlength)';
arousal2=smoothdata(arousal(:,1),'movmean',4);
plot(timesession,arousal2(:,1),'-',"Color",[.6 .3 .1],'LineWidth',2.);hold on;
plot(timesession,2*hit(:,1),'or','MarkerFaceColor',hitcolor,'MarkerEdgeColor',hitcolor);hold on;
yline(arousalmean+0.5*arousalstd,'--');hold on;
yline(arousalmean,'-');hold on;
yline(arousalmean-0.5*arousalstd,'--');hold on;
xlabel('Time (s)');ylabel('Arousal level');
set(gca,'FontSize',12,'LineWidth',3,'TickLength',[0.01 0.01]);
set(gca,'box','off');z1=arousalmean+2*arousalstd;ylim([0.05 0.7]);






