empuxo = load('Empuxo_Montenegro_10_03_2022.txt');


prop_mass = 4.621;
rocket_empty_mass = 26.169;
avg_thurst = mean(empuxo(:,2));
total_impulse = trapz(empuxo(:,1), empuxo(:,2));
isp = total_impulse/(prop_mass*9.81);
twr = max(empuxo(:,2))/(9.81*(rocket_empty_mass+prop_mass));