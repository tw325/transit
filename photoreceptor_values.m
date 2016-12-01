%%
figure(342)
clf(gcf)

int = linspace(0,1,100);

% dark bg
n = 2;
l50 = 0.01;
pmax = 1;

subplot(2,1,1)
plot(int,PhotoReceptor(pmax,n,l50,int))
axis square
xlim([0,1])
ylim([-1,0])
m = ['pmax ',num2str(pmax),' n: ',num2str(n),' L50: ',num2str(l50)];
title(m)


n = 1.6;
l50 = 0.5;
pmax = 1.5;
subplot(2,1,2)
plot(int,PhotoReceptor(pmax,n,l50,int))
axis square
xlim([0,1])
ylim([-1,0])
m = ['pmax ',num2str(pmax),' n: ',num2str(n),' L50: ',num2str(l50)];
title(m)

save2pdf('photoreceptor_params.pdf',gcf)