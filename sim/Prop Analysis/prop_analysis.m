empuxo = load('Empuxo_Montenegro_10_03_2022.txt');


prop_mass = 4.621;
rocket_empty_mass = 26.169;
avg_thurst = mean(empuxo(:,2));
total_impulse = trapz(empuxo(:,1), empuxo(:,2));
isp = total_impulse/(prop_mass*9.81);
twr = max(empuxo(:,2))/(9.81*(rocket_empty_mass+prop_mass));
max_thrust = max(empuxo(:,2));
max_thrust_index = find(empuxo(:,2) == max_thrust);

plot(empuxo(:,1), empuxo(:,2), 'LineWidth', 2)
txt = strcat('Max Thrust: ', num2str(max_thrust), ' N');
%txt = strcat('Max Thrust: ', '10');
text(empuxo(max_thrust_index,1) + 0.2, max_thrust, txt)
grid on
xlabel('Time (s)')
ylabel('Thrust (N)');
title('Thrust at 1800m ASL (N) over time (s)', 'Interpreter','latex')

saveas(gcf, 'thrust_curve_Montenegro_10_03_2022.png')