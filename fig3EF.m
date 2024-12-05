
% Beerendonk, Mejias et al. PNAS 2024
%
% Code for the computational model
%
% By Jorge Mejias, 2024


format short;clear all;
close all;clc;rng(938195);
Areas=1;Nareas=length(Areas);par=parameters(Areas);
bringparam(par);Iext=zeros(3,Nareas);Ipupil=Iext;Tpulse=1.5;mu0=0.013;


%external modulation 'E' to get the inverted U shape in d' (and U shape for RT)
i=1;Emin=0.25;Estep=0.01;Emax=0.6;E=Emin:Estep:Emax;Elength=length(E);dp=zeros(1,Elength);
Ntrials=3000;performance=zeros(2,Elength,Ntrials);meanRT=performance;C=0.02;
for j=1:Elength
    Enow=E(j);
    for trials=1:Ntrials
        %for this external modulation:
        Iext(1,:)=mu0*(1+C);
        Ipupil([1 2],:)=Enow;

        neurom=0.10;
        [rate,choice,RT]=trial(par,Iext,Ipupil,neurom,Nareas,Tpulse);
        %output:
        if choice==1           %hit!
            performance(1,i,trials)=1;
            meanRT(1,i,trials)=RT;
        elseif choice==0 %false alarm
            performance(2,i,trials)=1;
            meanRT(2,i,trials)=Tpulse;
        end

    end

    hitrate=sum(performance(1,i,:),3)/Ntrials;
    fArate=sum(performance(2,i,:),3)/Ntrials;
    %%given hit (hitrate) and false alarm rates (fArate, both between 0 and 1), 
    %%d' is given by: d prime = z(h)-z(fA)
    dp(1,i)=norminv(hitrate)-norminv(fArate);
    i=i+1;
end
performancem=mean(performance,3); %average over number of trials
meanRTm=mean(meanRT,3);


%we plot the result:
figure('Position',[200,800,800,300]);
subplot(1,2,1)
hitrate=sum(performance(1,:,:),3)/Ntrials;
fArate=sum(performance(2,:,:),3)/Ntrials;
dprima=norminv(hitrate)-norminv(fArate);
plot(E,dprima(1,:),'o-');hold on;
plot(E,zeros(1,length(E)),'--','Color',[0, 0, 0]);
ylabel('d prime');xlabel('arousal');
subplot(1,2,2) %we include a default 400 ms reaction time
plot(E,400.+1000.*(mean(meanRTm,1)),'o-');
ylabel('Reaction time (ms)');xlabel('arousal');







