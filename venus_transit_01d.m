% 01d: edge detection
% 01c: add non linearity
% 01b: add psf

close all
clear all

% (1-0.85(1-sqrt(1-r^2)^0.8))    a = 0.85, b = 0.80

% a=1;
% (1-a(1-sqrt(1-r^2)^0.8));

%  F(u) = 1 - a(1-u^b)   where:  u = sqrt(1-r^2)
%                        a = 0.85, b = 0.80


r=linspace(-1,1,1024);

venus=linspace(1,1,1024);
lgth=length(venus);
venus(lgth-lgth/5:35+lgth-lgth/5)=0;

a=1;b = 0.80;
% sun=(1-a(1-sqrt(1-r^2)^0.8));

u= sqrt(1-r.^2);
sun=1 - a*(1-u.^b);
pad=zeros(1,128);;
sun=[pad sun pad];
venus=[pad+1 venus pad+1];
%%
% ================ psf see Yang 2008 JZhejiangSciB,Lorenztian fx

L=11.9; %full width at half height, arcmin
L=4;
% x=[-1:.1:1]*45;
x=linspace(-1,1,21)*45;
psf=((L/2)^2)./((x.^2+(L/2)^2));
psf=psf/sum(psf);

% psf=fspecial('gaussian',[1 100],50);\

%%
% ==== non linearity
x3=linspace(0,10,1000);
x50=.25;
n=1.8;
r=(x3.^n)./(x50+(x3.^n));

%%
% ============= edge detection =========
sigma=32;
x2=linspace(-3*sigma,3*sigma,160);
DGauss=1*(x2./(2*pi*sigma^4)).*exp(-(x2.^2)/(2*sigma^2));

%%
% move venus across sun
figure(1)
subplot(1,3,1);plot(x,psf);title('psf');axis square
subplot(1,3,2);plot((x3),r,'b+');title('non-linearity');axis square
subplot(1,3,3);plot(x2,DGauss);title('edge detection');axis square


%%
% NOTE: in plots below, 0-1 (on the y-axis) corresponds to 0-100 cd/m2s
%   0-10 corresponds to 0-1000 cd/m2
%   0-100 corresponds to 0-10000 cd/m2
curr_venus=venus;
for i=1:length(sun)/2
    curr_venus=circshift(curr_venus,[0 1]);
    both=sun.*curr_venus;
    %     both1=conv(both,psf,'same');
    
    both2b=imfilter(both,psf)*100;
    both2=both2b-min(both2b);
    figure(2)
    subplot(1,4,1)
    %     plot(both1)
    %
    %         subplot(1,2,2)
    plot(both2)
    %     set(gca,'YScale','log')
    % ylim([250 500])
    xlim([0 1200])
    title('w/ psf')
    
    subplot(1,4,2)
    both3=(both2.^n)./(x50+(both2.^n));
    plot(both3)
    ylim([-.2 1.2])
    xlim([0 1200])
    title('w/ non-linearity')
    
    subplot(1,4,3)
    both4=imfilter(both3,DGauss);
    plot(both4)
    title('w/ edge detection')
    
    subplot(1,4,4)
    both5=both4+both3;
    plot(both5);
    ylim([-.2 1.2])
    title('edge detection added back to non-linearity')
    
    pause(.01)
end

