% parameters for the model:

%function [par]=parameters(Areas,dt)
function [par]=parameters(Areas)

Areas=1;
%parameters to scale mfr properly:
SF1=0.5;SF2=2.; %condition: SF1*SF2=1


Nareas=length(Areas);
% We put all the relevant parameters in the parameter structure "par":
par.dt=2.e-3; %previously, it was 0.5e-3;
par.triallength=5.;par.transient=1.;
par.gamma=0.641*SF2;par.gammai=SF2;
%time constants, in seconds:
taua=0.002;taur=taua;taug=0.005;taun=0.06; %tauNMDA=60ms, tauGABA=5ms
par.tau=[taur taur taur taun taun taug]; % r1,r2,r3(=rI),S1,S2,S3
par.tstep=((par.dt)./(par.tau))';
par.tstep=par.tstep*ones(1,Nareas);% to cover all areas
sig=1*0.03.*[1 1 0 0 0 0]; %noise on r1 and r2 (make 0.02 for DM), 0.03
par.tstep2=(((par.dt.*sig.*sig)./(par.tau)).^(0.5))';
par.tstep2=par.tstep2*ones(1,Nareas);% to cover all areas
par.binx=20;par.eta=0.5; %binx=50 means boxes of dt*binx=2ms


%parameters for SST and VIP:
par.Rsstmax=20;par.Rvipmax=20;
par.Jsst=-0.001;par.Jvip=-0.1;par.alphavip=50.;par.betavip=0;
par.alphasst=20.;par.betasst=32;par.Jtdsst=2.; %with this, input range is [0,1]
%%check the values for the SST and VIP firing rates and currents:
Mmin=0;Mstep=0.001;Mmax=1.;
Mlength=length(Mmin:Mstep:Mmax);topdown=zeros(Mlength,1);
Rv=topdown;Is=Rv;Rs=Rv;
i=1;
for M=Mmin:Mstep:Mmax
    z1=par.alphavip*M+par.betavip;
    if z1>par.Rvipmax z1=par.Rvipmax;end
    Rv(i,1)=z1;Is(i,1)=par.Jvip*Rv(i,1)+par.Jtdsst.*M; %topdown input to SST is stronger than to VIP
    z2=par.alphasst*Is(i,1)+par.betasst;
    if z2<0 z2=0;end
    Rs(i,1)=z2;topdown(i,1)=par.Jsst*Rs(i,1);
    i=i+1;
end
M=Mmin:Mstep:Mmax; %plot the activity of SST, VIP now:
% plot(M,Rv,'-o');hold on;plot(M,10*Is,'-o');hold on; %*10 is for visualization purposes
% plot(M,Rs,'-o');hold on;plot(M,1000*topdown,'-o');hold on; %*1000, same
% legend({'Rv','Is (x10)','Rs','topdown (x1000)'});xlabel('arousal');ylabel('topdown');
% min(topdown)
% max(topdown)




%f-I curve parameters:
par.ae=SF1*270;par.be=SF1*108;par.de=SF2*0.154;
par.invgi=SF1*0.5;par.c1=615;par.c0=177;par.r0=SF1*11.;

%----------
% local synaptic couplings (Jns and Jnie are set with the gradient):

% AMPA:
Jas=0.;          % EE self-population coupling
Jac=0.;          % EE cross-population coupling
Jaie=0.;         % E to I coupling
%GABA:
Jgei=-0.31;      % I to E coupling
Jgii=-0.12;      % I to I coupling
% NMDA:
Jns=0.49;        % EE self-population coupling
Jnc=0.0107;      % EE cross-population coupling
gi=1/(par.invgi);c1=par.c1;gammai=par.gammai;J0=0.2112;
zeta=c1*Jgei*taug*gammai/(gi-Jgii*taug*gammai*c1);
Jnie=0.5*(J0-Jns-Jnc)/(zeta);   % E to I coupling



J=zeros(3,6);
%we assign the weights:
J(1,1)=Jas;J(1,2)=Jac;J(1,3)=0;J(1,4)=Jns;J(1,5)=Jnc;J(1,6)=Jgei;
J(2,1)=Jac;J(2,2)=Jas;J(2,3)=0;J(2,4)=Jnc;J(2,5)=Jns;J(2,6)=Jgei;
J(3,1)=Jaie;J(3,2)=Jaie;J(3,3)=0;J(3,4)=Jnie;J(3,5)=Jnie;J(3,6)=Jgii;
par.J=J;


%background inputs (common to all areas)
I0e=0.3294;I0i=0.26;
par.inputbg=zeros(3,Nareas);
par.inputbg(1:2,:)=I0e;
par.inputbg(3,:)=I0i;
%decision threshold
par.threshold=15; % in sp/s, before it was 15




