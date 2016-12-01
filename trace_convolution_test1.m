clear all

imSize = 1600; %resolution of figure

X = 1:imSize;
X0 = (X/imSize) - .5;
[Xm,Ym] = meshgrid(X0, X0); %creates meshgrid

% ===================== 1. Solar limb darkening function ============
Rs = (Xm.^2)+(Ym.^2);
Rs0=(.75*max(Xm(:)) )^2;
ind=find(Rs>Rs0);
Rs(ind)=0;
a = 1; b = 0.8;
Solar_limb = 1-a*(1-(sqrt(1-Rs/Rs0).^b));
Solar_limb(ind)=0;

%===================== Venus =========================================
XB=(X / imSize) - .5;    % rescale X -> -.5 to .5
YB=(X / imSize) - .5; 
x_pos = round(imSize/2);
y_pos = round(imSize/5.8);
XB=circshift(XB,[0 x_pos-imSize/2]);
YB=circshift(YB,[0 y_pos-imSize/2]);
[Xm Ym] = meshgrid(XB, YB);
Rv = (Xm.^2)+(Ym.^2);
venus_to_sun = 1/15;
Rv0 = (venus_to_sun * sqrt(Rs0))^2;
[indV_out] =find(Rv>Rv0);
indV_in=find(Rv<=Rv0);
Rv(indV_out)=0; 
Rv(indV_in)=1;
Venus_disk = Rv;
figure(10); plot(Venus_disk(:,imSize/2));
%=============Point Spread Function==============================

psf = fspecial('gaussian', 100,30);

solar_limb_psf=imfilter(Solar_limb,psf);
venus_psf = Venus_disk;
venus_psf = imfilter(Venus_disk,psf);
% figure(10); plot(Venus_disk(:,imSize/2));
figure(5); plot(solar_limb_psf(:,imSize/2));


%============ Nonlinearity ==============================================
nW = 1.5;
L50W = .2;
nB = 1.5;
L50B = 0.1;

amp = 1;
solar_limb_nonlinear = amp * (solar_limb_psf.^nW)./(L50W^nW+solar_limb_psf.^nW);
venus_nonlinear = amp * (venus_psf.^nB)./(L50B^nB+venus_psf.^nB);

venus_nonlinear(venus_nonlinear>1)=1;
solar_limb_nonlinear(solar_limb_nonlinear>1)=1;

figure(11); plot(venus_nonlinear(:,imSize/2));

% figure();subplot(1,2,1);imagesc(venus_nonlinear);axis image; colormap(gray);
% subplot(1,2,2); plot(venus_nonlinear(:,imSize/2));
