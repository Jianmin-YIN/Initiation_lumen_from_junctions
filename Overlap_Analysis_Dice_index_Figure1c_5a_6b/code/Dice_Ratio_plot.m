

num = xlsread('overlap_analysis_Cdh5.xlsx');

[sorted_size,I]=sort(num(:,1));
CI=num(:,2);
sorted_index=CI(I);


c = linspace(0,1,length(CI));

figure
scatter(sorted_size,sorted_index,60,c,'filled');
grid on; box on;
legend off
set(gca,'linewidth',1.5);
set(gca,'FontSize', 16);
%%
saveas(gcf, 'cdh5_rasip1_ab.png');