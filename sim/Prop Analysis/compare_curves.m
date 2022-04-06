%montenegro_1003.l = 200;
%montenegro_0604.l = 220;


%montenegro_1003.radius = 72.2;
%montenegro_0604.radius = 70.2;


montenegro_0604 = load('Empuxo_Montenegro_06_04_2022.txt');
montenegro_1003 = load('Empuxo_Montenegro_10_03_2022.txt');

plot(montenegro_1003(:,1), montenegro_1003(:,2));
hold on
plot(montenegro_0604(:,1), montenegro_0604(:,2));
legend('10/03', '06/04')
