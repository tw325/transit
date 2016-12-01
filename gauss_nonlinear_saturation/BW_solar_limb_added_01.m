%source: http://www.icn.ucl.ac.uk/courses/MATLAB-Tutorials/Elliot_Freeman/html/gabor_tutorial.html
%close all
clear all
imSize = 1600;    % image size: n X n

%%
%=======make linear ramp
X = 1:imSize;
X0 = (X / imSize) - .5;    % rescale X -> -.5 to .5
[Xm Ym] = meshgrid(X0, X0); % 2D Meshgrid

%%
%=============Make 2D Solar Limb Darkening Model
Rs = (Xm.^2)+(Ym.^2);
Rs0=(.75*max(Xm(:)) )^2;
ind=find(Rs>Rs0);
Rs(ind)=0;
a = 1; b = 0.8;
solar_limb = 1-a*(1-(sqrt(1-Rs/Rs0).^b));
solar_limb(ind)=0;

%%
% SOLAR LIMB NONLINEARITY
nW = 5;
L50W = 0.8;
solar_limb_nonlinear= (solar_limb.^nW)./(L50W+solar_limb.^nW);

venusind = linspace(imSize/4,1,50);
for i=1:length(venusind);
x_pos=round(imSize/2);
y_pos=round(venusind(i));

X = 1:imSize;             % X is a vector from 1 to imageSize
XB = (X / imSize) - .5;    % rescale X -> -.5 to .5
YB= (X / imSize) - .5; 
XB=circshift(XB,[0 x_pos-imSize/2]);
YB=circshift(YB,[0 y_pos-imSize/2]);
[Xm Ym] = meshgrid(XB, YB);             % 2D matrices

%%
%=============Make 2D Black Gaussian blob ==========================================
sigma = 0.01;    % gaussian standard deviation in pixels
gaussB = -exp( -(((Xm.^2)+(Ym.^2)) ./ (2* sigma^2)) ); % formula for 2D gaussian
ind=find(gaussB>-.0011);
gaussB(ind)=0;
ind=find(gaussB~=0);

%%
%NONLINEARITY gaussB
nB = 1;
L50B = 0.1;
gaussBNL=gaussB.*-1;
gaussBNL= (gaussBNL.^nB)./(L50B+gaussBNL.^nB);

%% SATURATING SOLAR LIMB AND GAUSSIAN
amp = 20;
solar_limb_saturated=(solar_limb_nonlinear*amp);
solar_limb_saturated(solar_limb_saturated>10)=10;
gaussBNL= gaussBNL.*-amp+1;
gaussBNL(gaussBNL<0)=0;

%========= FINAL FIGURE ===================================
stimulus_figure = solar_limb_saturated + gaussBNL-1;
stimulus_figure(stimulus_figure>1)=1;
stimulus_figure(stimulus_figure<0)=0;

limx = [imSize*3/8,imSize*5/8];
limy = [1,imSize/4];

figure(5);clf;
subplot(1,2,1);imagesc( stimulus_figure, [0 1] ); colormap(gray); axis on; axis image; 
title('Solar Limb W/ Black Nonlinear'); xlim(limx);ylim(limy);     
subplot(1,2,2);plot(diag(stimulus_figure));ylim([-0.5 1.5]); xlim([200 1400]);axis square;
%[BW1 thresh] = edge(stimulus_figure,'canny',[-1,0.04],.2); figure(6); clf;ttx=BW1*0+1; imshow(xor(BW1,ttx));
pause();
end;
