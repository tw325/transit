clear all

imSize = 1600; %resolution of figure

X = 1:imSize;
X0 = (X/imSize) - .5
[Xm Ym] = meshgrid(X0, X0); %creates meshgrid

% --------------- 1. Solar limb darkening function ------
Rs = (Xm.^2)+(Ym.^2);
Rs0=(.75*max(Xm(:)) )^2;
ind=find(Rs>Rs0);
Rs(ind)=0;
Solar_limb = 1-1*(1-(sqrt(1-Rs/Rs0).^0.8));
Solar_limb(ind)=0;

% Solar_limb = Solar_limb * 100; 
% ind=find(Solar_limb>100);
% Solar_limb(ind)=100;

%--------Venus---------------------------------------
XB=(X / imSize) - .5;    % rescale X -> -.5 to .5
YB=(X / imSize) - .5; 
x_pos = round(imSize/2);
y_pos = round(imSize/5);
XB=circshift(XB,[0 x_pos-imSize/2]);
YB=circshift(YB,[0 y_pos-imSize/2]);
[Xm Ym] = meshgrid(XB, YB);
Rv = (Xm.^2)+(Ym.^2);
venus_to_sun = 1/10;
Rv0 = (venus_to_sun * sqrt(Rs0))^2;
[indV_out] =find(Rv>Rv0);
Rv(indV_out)=1;
indV_in=find(Rv<=Rv0);
Rv(indV_in)=0;
Venus_disk = Rv;


% ================ Point Spread Function (use Yang 2008 JZhejiangSciB,Lorenztian fx)

L=10; %full width at half height, arcmin
%L=4;
% x=[-1:.1:1]*45;
psf_size=25;
Xp=1:psf_size;
XP=((Xp / psf_size)) - .5;
[Xm Ym] = meshgrid(XP, XP);
Rp = (Xm.^2)+(Ym.^2);
minRp=(min(Rp(1,:)));
Rp=45*Rp/minRp;
ind=find(Rp>45);
Rp(ind)=0;
% x=linspace(-1,1,psf_size)*45;
psf=((L/2)^2)./((Rp.^2+(L/2)^2));
psf(ind)=0;
sumRp=sum((psf(:)));
psf=psf/sumRp;

%psf = fspecial('gaussian', psf_size, 20);
%both1=conv(both,psf,'same');
% stimulus_psf=imfilter(stimulus_orig,psf);
solar_limb_psf=imfilter(Solar_limb,psf);
venus_psf=imfilter(Venus_disk,psf);

stim_orig_psf=solar_limb_psf.*venus_psf;
num=max(venus_psf(:));
% vemus_psf=venus_psf/num;
venus_psf(1:round(psf_size/2),:)=num;
venus_psf(end-round(psf_size/2):end,:)=num;
venus_psf(:,1:round(psf_size/2))=num;
venus_psf(:,end-round(psf_size/2):end)=num;
num=1-num;
indV_in=find(venus_psf<1-num); %check venus_psf
indV_out=find(venus_psf>=1-num);

%-----------------Nonlinearity-----------------
nW = 2; %2.2
L50W = 0.9;
nB = 2;
L50B = 0.5;
%stimulus_neur = (stimulus_opt.^nW)./(L50W^nW+stimulus_opt.^nW);

amp = 7;
solar_limb_nonlinear = (solar_limb_psf.^nW)./(L50W^nW+solar_limb_psf.^nW)*amp;
venus_nonlinear = (venus_psf.^nB)./(L50B^nB+venus_psf.^nB)*amp;

% venus_nonlinear(venus_nonlinear>1)=1;
% solar_limb_nonlinear(solar_limb_nonlinear>1)=1;
% stimulus_neur = solar_limb_nonlinear * venus_nonlinear;

stimulus_neur = solar_limb_nonlinear - (amp - venus_nonlinear);

% temp= (stimulus_opt(indV_out).^nW)./(L50W^nW+stimulus_opt(indV_out).^nW); %correct one
% stimulus_neur=stimulus_opt;
% stimulus_neur(indV_out)=temp;
% 
% temp= (stimulus_opt(indV_in).^nB)./(L50B^nB+stimulus_opt(indV_in).^nB); %correct one
% stimulus_neur(indV_in)=temp;

%------------------------Setting final model----------------------
stimulus_figure = stimulus_neur;

%------------------------Figures-----------------------------------
figure(1);subplot(2,2,1);imagesc(stimulus_figure, [0 1] ); colormap(gray); axis image;
hold on; plot([imSize/2 imSize/2],[1 imSize], 'r'); hold off;
subplot(2,2,2); plot(stimulus_figure(:,imSize/2),'r');axis square;
subplot(2,2,3);plot(venus_nonlinear(:,imSize/2));axis square;
subplot(2,2,4);plot(solar_limb_nonlinear(:,imSize/2));axis square;
% hold on; plot(stimulus_orig(:,imSize/2),'k'); hold off;
    
%---------------------------------------------------------