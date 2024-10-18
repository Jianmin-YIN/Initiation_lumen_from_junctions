N = 4;
Color = linspecer(N) ;

num = xlsread('PIV_pulse.xlsx');

figure
[r1,c1]=size(num);
X=(0:1:(r1-1))*2;
plot(X,smooth(num(:,2),1)*0.29/2,X,smooth(num(:,1),1)*0.17/2, 'LineWidth',3);
grid on; box on;

set(gca,'linewidth',1.5);
set(gca,'FontSize', 24);
xlim([0,48]);
%%
saveas(gcf, 'PIV_pulse.png');