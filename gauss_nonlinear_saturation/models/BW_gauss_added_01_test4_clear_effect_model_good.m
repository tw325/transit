%
% 10-9-2013 note save 'sta2' as model V1 cell RF
%
% source: http://www.icn.ucl.ac.uk/courses/MATLAB-Tutorials/Elliot_Freeman/html/gabor_tutorial.html
%close all
clear all

nW = 2; %n of Sun
L50W = .05; %L50 of Sun (originally 0.1) try 0.01
amp = 16; %saturation of Sun (originally 32) try 4.5
ampB=1; %saturation of Linear Venus 
ampBNL=-16; %saturation of Nonlinear Venus (originally -15)
nB =1; %n of Venus
L50B = 0.05; %L50 of Venus

pix_per_deg=18/8; %/8 for Hartley8
s1=linspace(0,2*pi,100);

%%
%============================================
% white Gauss
imSize = 400;    % image size: n X n
lamda = imSize*2*2;     % wavelength (number of pixels per cycle)
theta = 0;    % grating orientation
sigma = 80;    % gaussian standard deviation in pixels
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
s = sigma / imSize;                     % gaussian width as fraction of imageSize
gaussW = exp( -(((Xm.^2)+(Ym.^2)) ./ (2* s^2)) ); % formula for 2D gaussian
curveW = diag(gaussW);
figure(1);subplot(2,4,2); plot(curveW);colormap(gray); axis square;                   % display
%axis on; axis image;     % use gray colormap

%%
%NONLINEARITY gaussW
% nW = 2.2;
% L50W = 0.1;
gaussWNL= (gaussW.^nW)./(L50W^nW+gaussW.^nW);
nonlinear = linspace(0,1,100);
nonlinear = (nonlinear.^nW)./(L50W^nW+nonlinear.^nW);
% curveNL = diag(nonlinear);
subplot(2,4,3); plot(nonlinear);colormap(gray); axis square;
subplot(2,4,4); plot(diag(gaussWNL)); colormap(gray); axis square;
temp = [1 100];
%figure(2);plot(temp.^nW)./(L50W^nW+temp.^nW);% ylim([-2 30]); axis square;

%%
% ==========================================
% black Gauss
% imSize = 48;    % image size: n X n
% lamda = 96*2;     % wavelength (number of pixels per cycle)
% theta = 0;    % grating orientation
sigma = 7;    % gaussian standard deviation in pixels (originally 3)
phase = 0.75;    % phase (0 -> 1)
trim = .05;    % trim off gaussian values smaller than this
x_pos=102; % centr pos =24,24
y_pos=102;

%gaussW=(gaussW*amp)-1;
%gaussWNL=gaussWNL*2;
gaussWNL=(gaussWNL*amp);
curve10 = diag(gaussWNL);
subplot(2,4,5); plot(curve10); axis square;ylim ([-2, 16]);
gaussWNL= gaussWNL -1;
curve = diag(gaussWNL);
subplot(2,4,6);plot(curve); ylim([-2 30]); axis square; ylim([-2,16]);
subplot(2,4,7);plot(curve); ylim([-2 30]); axis square; ylim([-2,16]);
hold on;
plot([0 400],[1 1],'r');
hold off;
% fname=['C:\Users\Tyler\Desktop\Matlab\gaussWNL2.png'];
% saveas(3,fname);
% curveW = diag(gaussW);
% figure(2);plot(curveW); ylim([-2 30]); axis square;
% hold on;
% plot([0 400],[1 1],'r');
% hold off;
% fname=['C:\Users\Tyler\Desktop\Matlab\gaussW2.png'];
% saveas(2,fname);


for i=150:-1:50
%i=55;
x_pos=i; % sim_real1 is 66,83
y_pos=i;
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
s = sigma / imSize;                     % gaussian width as fraction of imageSize
gaussB = -exp( -(((Xm.^2)+(Ym.^2)) ./ (2* s^2)) ); % formula for 2D gaussian
ind=find(gaussB>-.0011);
gaussB(ind)=0;
ind=find(gaussB~=0);
gaussB=gaussB*ampB;
curveB = diag(gaussB);
%figure(9);plot(curveB); colormap(gray); %xlim([0 200]);
% gaussB(ind)=gaussB(ind)*-1;
%figure(2);imagesc( gaussB, [-1 1] ); colormap(gray)                       % display
%axis on; axis image;     % use gray colormap

%%
%NONLINEARITY gaussB
% nB = 1;
% L50B = 0.1;
gaussBNL=gaussB.*-1;
gaussBNL= (gaussBNL.^nB)./(L50B^nB+gaussBNL.^nB);
nonlinear = linspace(0,1,100);
nonlinear = (nonlinear.^nB)./(L50B^nB+nonlinear.^nB);
%figure(2);plot(nonlinear); colormap(gray);  
gaussBNL= gaussBNL.*ampBNL;

%%
% amp = 32;
%gaussW=gaussW*2;
% gaussW=(gaussW*amp)-1;
% %gaussWNL=gaussWNL*2;
% gaussWNL=(gaussWNL*amp)-1;
%gaussWNL(gaussWNL>1)=1;
% gaussW=gaussW*3;
gaussWB=gaussW+gaussB;
gaussWNLB = gaussWNL + gaussB;
gaussWNLBNL = gaussWNL + gaussBNL;
gaussWNLBNL = gaussWNLBNL(1:150,1:150);
%curve3 = diag(gaussWNLBNL);
%subplot(1,4,4);drawmat(gaussWNLBNL,.2,.01,10,'r'); axis square;
gaussWNLBNL(gaussWNLBNL>1)=1;
subplot(2,4,8);plot(diag(gaussWNLBNL)); colormap(gray); axis square; ylim([-1.5,1.5]);
gaussWNLBNL(gaussWNLBNL<-1)=-1;

%[BW1 thresh] = edge(interp2(gaussWNLBNL,'spline',8),'canny',[0.04,0.06],0.1); figure(5); clf;ttx=BW1*0+1; imshow(xor(BW1,ttx));
%[BW1 thresh] = edge(gaussWNLBNL,'canny',[0.02,0.06],0.5); subplot(1,4,3); ttx=BW1*0+1; imshow(xor(BW1,ttx));

%[0.02,0.05],0.05
subplot(2,4,1);imagesc( gaussWNLBNL, [-1 1] ); colormap('gray'); axis on; axis image;%axis on; title('White Nonlinear Black Nonlinear');
%hold on; plot([0 400],[0 400],'k--'); hold off;
%subplot(2,4,1);imagesc( gaussWB, [-1 1] ); colormap(gray); axis on; axis image; title('Linear');
%subplot(2,4,2);imagesc( gaussWNLB, [-1 1] ); colormap(gray); axis on; axis image; title('White Nonlinear'); 
%subplot(2,4,3);imagesc( gaussWNLBNL, [-1 1] ); colormap(gray); axis on; axis image; title('White Nonlinear Black Nonlinear');     
% use gray colormap

% subplot(1,3,1);imagesc( gaussWNLBNL, [-1 1] ); colormap(gray); axis on; axis image; title('White Nonlinear Black Nonlinear');  
curve1 = diag(gaussBNL);
curve2 = diag(gaussWNL);
curve3 = diag(gaussWNLBNL);
%figure(10); plot(curve3); %ylim([-2 2]);
% hold on;
% plot([0 400],[1 1],'k--');
% plot([0 400],[-1 -1],'k--');
% %plot([0 400],[0 0],'k');
% hold off;
%subplot(2,4,4);plot(curve1);ylim([-amp amp]);
%subplot(1,3,2);
%figure(5);plot(curve2);ylim([-1 1]); axis square;
% hold on; plot(curve1,'r');
% hold off;
% figure();
% subplot(1,2,2);plot(curve3);ylim([-1.5 1.5]); axis square;
% hold on;
% plot([0 200],[0 0],'b--');
% hold off;
%imwrite(gaussWNLBNL,'simulation.png');
% fname=['C:\Users\Tyler\Desktop\Matlab\aureole\aureole' num2str(i) '.png'];
% saveas(4,fname);
% fname=['C:\Users\Tyler\Desktop\Matlab\combined\combined' num2str(i) '.png'];
% saveas(6,fname);
% fname=['C:\Users\Tyler\Desktop\Matlab\red_blue\red_blue' num2str(i) '.png'];
% saveas(5,fname);
pause();
end
