tape = load('tape10m_06042022.txt');

thrust_curve = tape(:,1:3);
thrust_curve(:,2) = [];
plot(thrust_curve(:,1), thrust_curve(:,2))

writematrix(thrust_curve, 'Empuxo_Montenegro_06_04_2022.txt')