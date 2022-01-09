%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Graph 1                        %
%               Plotting CD vs AoA                 %
%                                                  %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
zero = find(dados.alpha == 0);
interesting_alphas = dados.alpha(zero:end);

phi_0 = 1; % Pegando phi = 0
cg_cheio = size(dados.cg, 2);  % Pegando CG cheio

hold on
for k = 1:size(dados.mach,2)
    txt = ['M = ', num2str(dados.mach(k))];
    plot(interesting_alphas, reshape(M.CD(phi_index, k, zero:end, cg_cheio), size(dados.alpha(zero:end), 2), 1), 'DisplayName', txt)
end
hold off
title('$C_D$ vs AoA (100\% Fuel)', 'Interpreter','latex');
ylabel('$C_D$', 'Interpreter','latex');
xlabel('Angle of Attack (Degrees)', 'Interpreter','latex');
legend show
legend('Location', 'northwest')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Graph 2                        %
%               Plotting CD vs Mach                %
%                                                  %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h2 = figure;
zero = find(dados.alpha == 0);
interesting_alphas = dados.alpha(zero:end);

phi_index = 1;
cg_cheio = size(dados.cg, 2);

hold on
for k = 1:2:size(interesting_alphas,2)
    txt = ['$\alpha$ = ', num2str(interesting_alphas(k))];
    plot(dados.mach, reshape(M.CD(phi_index, :, zero+k-1, cg_cheio), size(dados.mach, 2), 1), 'DisplayName', txt, 'LineWidth', 1)
end
hold off
title('$C_D$ vs Mach (100\% Fuel)', 'Interpreter','latex');
ylabel('$C_D$', 'Interpreter','latex');
xlabel('Mach', 'Interpreter','latex');
legend show
legend('Location', 'northwest', 'Interpreter','latex')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Graph 3                         %
%             Plotting Static Margin                %
%   Obs: O Datcom considera a saída "XCP" direto    %
% como a Margem estática. Para mais informações,    %
% consultar a página 54 do manual do Datcom, versão %
% de dezembro de 1999.                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
zero = find(dados.alpha == 0);
interesting_alphas = dados.alpha(zero:end);

phi_index = 1;
alpha_index = zero; % Pegando ângulo de ataque nulo

hold on
for k = 1:size(dados.cg,2)
    fuel_percent = (k - 1)*100/(size(dados.cg,2) - 1);
    txt = ['Fuel = ', num2str(fuel_percent), '\%'];
    plot(dados.mach, reshape(-M.XCP(phi_index, :, alpha_index, k), size(dados.mach, 2), 1), 'DisplayName', txt, 'LineWidth', 1)
end
hold off
title('Static Margin vs Mach (100\% Fuel)', 'Interpreter','latex');
ylabel('Static Margin', 'Interpreter','latex');
xlabel('Mach', 'Interpreter','latex');
launching_static_margin = -M.XCP(phi_index, 1, alpha_index, cg_cheio);
txt = ['\leftarrow Static Margin at Launch = ', num2str(launching_static_margin)];
text(dados.mach(1), launching_static_margin, txt)
legend show
legend('Location', 'northwest', 'Interpreter','latex')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Graph 4                         %
%          Plotting Static Margin with Wind         %
%   Obs: O Datcom considera a saída "XCP" direto    %
% como a Margem estática. Para mais informações,    %
% consultar a página 54 do manual do Datcom, versão %
% de dezembro de 1999.                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MaxVento = 15; % V máxima de vento para o lançamento 
Lref = 0.152;  % Área de referência do foguete (6' = 0.152 m)
ang_lanc = 86; % Ângulo de lançamento
% Cálculo da velocidade do som
gamma = 1.4;
R = 287;
a = sqrt(gamma*R*(T+273.15));

% Vetor velocidade
v = dados.mach*a;
v_saida_rampa = v(1);

ang_lanc = deg2rad(90-ang_lanc);
ang_vento = deg2rad(90);

iter_vento = 197;            % Discretizacao do vento.
iter_vel = 14;               % Discretizacao da velocidade.

