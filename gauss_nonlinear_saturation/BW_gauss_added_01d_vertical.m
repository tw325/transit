%
% 10-9-2013 note save 'sta2' as model V1 cell RF
%
% source: http://www.icn.ucl.ac.uk/courses/MATLAB-Tutorials/Elliot_Freeman/html/gabor_tutorial.html
%close all
clear all

%%
%============================================
% white Gauss
imSize = 1600;    % image size: n X n
lamda = imSize*2*2;     % wavelength (number of pixels per cycle)
theta = 0;    % grating orientation
sigma = 0.15;    % gaussian standard deviation in pixels
phase = 0.25;    % phase (0 -> 1)
trim = .05;    % trim off gaussian values smaller than this

%%
%=======make linear ramp
X = 1:imSize;             % X is a vector from 1 to imageSize
X0 = (X / imSize) - .5;    % rescale X -> -.5 to .5

%%
%=============Now make a 2D grating
% Start with a 2D ramp use meshgrid to make 2 matrices with ramp values across columns (Xm) or across rows (Ym) respectively

[Xm Ym] = meshgrid(X0, X0);             % 2D matrices
% imagesc( [ Xm Ym ] );                   % display Xm and Ym
% colorbar; axis on                      % add colour bar to see values

%%
%=============Make 2D gaussian blob
s = sigma;                     % gaussian width as fraction of imageSize

gaussW = exp( -(((Xm.^2)+(Ym.^2)) ./ (2* s^2)) ); % formula for 2D gaussian
%figure(1);imagesc( gaussW, [-1 1] ); colormap(gray)                       % display
%axis on; axis image;     % use gray colormap

%%
%NONLINEARITY gaussW
nW = 2.2;
L50W = 0.1;
gaussWNL= (gaussW.^nW)./(L50W+gaussW.^nW);


%%
% ==========================================
% black Gauss
% imSize = 48;    % image size: n X n
% lamda = 96*2;     % wavelength (number of pixels per cycle)
% theta = 0;    % grating orientation
sigma = 0.01;    % gaussian standard deviation in pixels
phase = 0.75;    % phase (0 -> 1)
trim = .05;    % trim off gaussian values smaller than this
x_pos=round(imSize*.5); % centr pos =24,24
y_pos=round(imSize*.2);
%%
%=======make linear ramp
X = 1:imSize;             % X is a vector from 1 to imageSize
XB = (X / imSize) - .5;    % rescale X -> -.5 to .5
YB= (X / imSize) - .5; 
XB=circshift(XB,[0 x_pos-imSize/2]);
YB=circshift(YB,[0 y_pos-imSize/2]);
%%
%=============Now make a 2D grating
% Start with a 2D ramp use meshgrid to make 2 matrices with ramp values across columns (Xm) or across rows (Ym) respectively

[Xm Ym] = meshgrid(XB, YB);             % 2D matrices
% imagesc( [ Xm Ym ] );   
% imagesc( [ Xm ] );% display Xm and Ym
% colorbar; axis on                      % add colour bar to see values

%%
%=============Make 2D gaussian blob
s = sigma;                     % gaussian width as fraction of imageSize
gaussB = -exp( -(((Xm.^2)+(Ym.^2)) ./ (2* s^2)) ); % formula for 2D gaussian
ind=find(gaussB>-.0011);
gaussB(ind)=0;
ind=find(gaussB~=0);
gaussB=gaussB*1;
% gaussB(ind)=gaussB(ind)*-1;
%figure(2);imagesc( gaussB, [-1 1] ); colormap(gray)                       % display
%axis on; axis image;     % use gray colormap

%%
%NONLINEARITY gaussB
nB = 1;
L50B = 0.1;
gaussBNL=gaussB.*-1;
gaussBNL= (gaussBNL.^nB)./(L50B+gaussBNL.^nB);
gaussBNL= gaussBNL.*-15;

%%
amp = 32;
gaussW=(gaussW*amp)-1;
gaussWNL=(gaussWNL*amp)-1;
%gaussWNL(gaussWNL<0.95)=-1; % without tail, Venus has no blister

%gaussWNL(gaussWNL>1)=1; COMMENT TO SHOW BLUR
gaussWNLBNL = gaussWNL + gaussBNL;
limx = [imSize*3/8,imSize*5/8];
limy = [1,imSize/4];
figure();clf;
subplot(1,3,1);imagesc( gaussWNLBNL, [-1 1] ); colormap(gray); axis on; axis image; title('White Nonlinear Black Nonlinear'); xlim(limx);ylim(limy);     
hold on; plot([imSize/2 imSize/2],[1 imSize], 'r'); hold off;
subplot(1,3,2); plot(gaussWNLBNL(:,imSize/2),'r');ylim([-1.5 1.5]); axis square;
hold on; plot(gaussWNL(:,imSize/2),'k'); hold off;
subplot(1,3,3);plot(gaussBNL(:,imSize/2)); axis square;





