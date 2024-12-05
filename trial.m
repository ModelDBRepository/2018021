% Single trial for the network of 30 areas
%

function [rate,choice,RT]=trial(par,Iext,Ipupil,Imod,Nareas,Tpulse)
	

% we rewrite the par structure into local parameters for readiness:
dt=par.dt;triallength=par.triallength;
transient=par.transient;tau=par.tau;
tstep=par.tstep;tstep2=par.tstep2;
gamma=par.gamma;gammai=par.gammai;
ae=par.ae;be=par.be;de=par.de;
invgi=par.invgi;c1=par.c1;c0=par.c0;r0=par.r0;
J=par.J;inputbg=par.inputbg;
threshold=par.threshold;
alphavip=par.alphavip;betavip=par.betavip;
alphasst=par.alphasst;betasst=par.betasst;
Jvip=par.Jvip;Jsst=par.Jsst;
Rvipmax=par.Rvipmax;Jtdsst=par.Jtdsst;
auxones=ones(3,Nareas);

%we set up the variables for this trial:
irate=zeros(6,Nareas);
iratenew=zeros(6,Nareas);
rate=zeros(6,round(triallength/dt),Nareas);
totalinput=zeros(3,Nareas);
totalinput2=zeros(3,Nareas,100);totalinput3=totalinput2;
inoise=zeros(3,Nareas);
transfer=zeros(3,Nareas);
xi=normrnd(0,1,3,round(triallength/dt),Nareas); %noise
input=zeros(3,Nareas);
ounoise=zeros(3,Nareas);

%first iteration:
rate(1:3,1,:)=5*(1+tanh(2.*xi(:,1,:))); %r1,2,3 --> [0,10] spikes/s
rate(4:6,1,:)=0; %S1,2,3
choice=0; % it will end up being 0 (no choice), 1 or 2 (for pops 1&2)
RT=1.5; % reaction time, it will be shorter than this if there's decision

%Now we start the real simulation:
i=2;kk=1;
for time=2*dt:dt:triallength
	
  %we set the instantaneous rates and conductances:
  irate(:,:)=rate(:,i-1,:);  %6x30
  
  %noise (OU process):
  inoise(:,:)=xi(:,i-1,:);
  ounoise(:,:)=ounoise(:,:)+tstep(1:3,:).*(-ounoise(:,:))+...
  tstep2(1:3,:).*inoise;
  
  %total FF input to r1,2,3 of each area:
  input=inputbg+ounoise; %3x30
  if time>=2 && time<(2+Tpulse)
      input=input+Iext;
  end

  %top-down input (same for E1&2, and transformed via SST and VIP)(also, neuromodulation):
  Rvip=alphavip*(0.1*Ipupil(1)+Imod+0.26)+betavip;if Rvip>Rvipmax Rvip=Rvipmax;end
  Isst=Jvip*Rvip+Jtdsst.*(0.1*Ipupil(1)+Imod+0.26); %topdown input to SST is stronger than to VIP
  Rsst=alphasst*Isst+betasst;if Rsst<0 Rsst=0;end
  input([1 2],:)=input([1 2],:)+Jsst*Rsst; %adding the top-down input to E1&2
  %input(1,:)=input(1,:)+Jsst*Rsst; %adding the top-down input only to E1

  %local interactions through regular connections:
  totalinput(:,:)=input+J*irate(:,:); %3x30, J*irate is (3x6)*(6x30)

    
  %Input after transfer functions. Excitatory populations:
  transfer(1:2,:)=(ae.*totalinput(1:2,:)-be)./(auxones(1:2,:)...
  -exp(-de*(ae.*totalinput(1:2,:)-be)));
  %Inhibitory populations:
  %threshold-linear f-I curve:
  transfer(3,:)=invgi*c1.*totalinput(3,:)-invgi*c0+r0;
  transfer(3,transfer(3,:)<0)=0;  
  
  %we evolve the firing rates of all areas:
  iratenew(1:3,:)=irate(1:3,:)+tstep(1:3,:).*(-irate(1:3,:)+transfer(:,:));
  %and also the NMDA conductances:
  taun=tau(4);taug=tau(6);
  iratenew(4:5,:)=irate(4:5,:)+tstep(4:5,:).*...
  (-irate(4:5,:)+gamma*taun*(ones(2,Nareas)-irate(4:5,:)).*irate(1:2,:));
  %and GABA conductances:
  iratenew(6,:)=irate(6,:)+tstep(6,:).*(-irate(6,:)+taug*gammai.*irate(3,:));

  %let's check for a decision:
  if choice==0
      if iratenew(1,1)>threshold
          choice=1;
          RT=time-2;
      elseif iratenew(2,1)>threshold
          choice=2;
          RT=time-2;
      end
  end
  
  %update and index iteration:
  rate(:,i,:)=iratenew(:,:);i=i+1;
end







