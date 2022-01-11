savefigs = true;

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
    plot(interesting_alphas, reshape(M.CD(phi_0, k, zero:end, cg_cheio), size(dados.alpha(zero:end), 2), 1), 'DisplayName', txt)
end
hold off
title('$C_D$ vs AoA (100\% Fuel)', 'Interpreter','latex');
ylabel('$C_D$', 'Interpreter','latex');
xlabel('Angle of Attack (Degrees)', 'Interpreter','latex');
legend show
legend('Location', 'northwest')

if savefigs
    file = ['Graphics/CDvsAoA', datestr(clock,'YYYY_mm_dd'), '.png'];
    saveas(gcf, file);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Graph 2                        %
%               Plotting CD vs Mach                %
%                                                  %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h2 = figure;
zero = find(dados.alpha == 0);
interesting_alphas = dados.alpha(zero:end);

phi_0 = 1;
cg_cheio = size(dados.cg, 2);

hold on
for k = 1:2:size(interesting_alphas,2)
    txt = ['$\alpha$ = ', num2str(interesting_alphas(k))];
    plot(dados.mach, reshape(M.CD(phi_0, :, zero+k-1, cg_cheio), size(dados.mach, 2), 1), 'DisplayName', txt, 'LineWidth', 1)
end
hold off
title('$C_D$ vs Mach (100\% Fuel)', 'Interpreter','latex');
ylabel('$C_D$', 'Interpreter','latex');
xlabel('Mach', 'Interpreter','latex');
legend show
legend('Location', 'northwest', 'Interpreter','latex')

if savefigs
    file = ['Graphics/CDvsMACH', datestr(clock,'YYYY_mm_dd'), '.png'];
    saveas(gcf, file);
end


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

phi_0 = 1;
alpha_index = zero; % Pegando ângulo de ataque nulo

hold on
for k = 1:size(dados.cg,2)
    fuel_percent = (k - 1)*100/(size(dados.cg,2) - 1);
    txt = ['Fuel = ', num2str(fuel_percent), '\%'];
    plot(dados.mach, reshape(-M.XCP(phi_0, :, alpha_index, k), size(dados.mach, 2), 1), 'DisplayName', txt, 'LineWidth', 1)
end
hold off
title('Static Margin vs Mach (100\% Fuel)', 'Interpreter','latex');
ylabel('Static Margin', 'Interpreter','latex');
xlabel('Mach', 'Interpreter','latex');
launching_static_margin = -M.XCP(phi_0, 1, alpha_index, cg_cheio);
txt = ['\leftarrow Static Margin at Launch = ', num2str(launching_static_margin)];
text(dados.mach(1), launching_static_margin, txt)
legend show
legend('Location', 'northwest', 'Interpreter','latex')

if savefigs
    file = ['Graphics/StaticMargin', datestr(clock,'YYYY_mm_dd'), '.png'];
    saveas(gcf, file);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Graph 4                         %
%          Plotting Static Margin with Wind         %
%   Obs: O Datcom considera a saída "XCP" direto    %
% como a Margem estática. Para mais informações,    %
% consultar a página 54 do manual do Datcom, versão %
% de dezembro de 1999.                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

max_wind = 10; % Maximum wind speed analyzed 
Lref = 0.152;  % Rocket's area of reference (6' = 0.152 m)
launch_angle = 86; % Launch angle
% Speed of sound
T = 27;
gamma = 1.4;
R = 287;
a = sqrt(gamma*R*(T+273.15));

% Velocity vector
v = dados.mach*a;
ramp_v = v(1);

launch_angle = deg2rad(90-launch_angle);
wind_angle = deg2rad(90);

iter_wind = 197;            % Wind discretization
iter_vel = 14;              % Rocket velocity discretization

min_v = ramp_v - 5;   % Min and max velocity values we are searching through
max_v = ramp_v + 5;  
mod_Vwind = linspace(0, max_wind, iter_wind);
mod_Vrocket = linspace(min_v, max_v, iter_vel);

% Variable initalization
v_rocket = zeros(2, length(mod_Vrocket));
v_wind = zeros(2, length(mod_Vrocket));
v_total = zeros(2, length(mod_Vwind));
cos_angle(length(mod_Vrocket), length(mod_Vwind)) = 0;
angle_of_attack(length(mod_Vrocket), length(mod_Vwind)) = 0;
alpha(length(mod_Vrocket)) = 0;
static_margin(length(mod_Vrocket), length(mod_Vwind)) = 0;

v_rocket(1,:) = mod_Vrocket*cos(launch_angle);
v_rocket(2,:) = mod_Vrocket*sin(launch_angle);

% Calculations

for i = 1:length(mod_Vrocket)
    for j = 1:length(mod_Vwind)
        v_wind(1,j) = mod_Vwind(j)*cos(wind_angle);
        v_wind(2,j) = mod_Vwind(j)*sin(wind_angle);

        v_total(1,j) = v_rocket(1,i) + v_wind(1,j);
        v_total(2,j) = v_rocket(2,i) + v_wind(2,j);

        cos_angle(i,j) = dot([v_rocket(1,i); v_rocket(2,i)], [v_total(1,j); v_total(2,j)])/(norm([v_total(1,j); v_total(2,j)])*norm([v_rocket(1,i); v_rocket(2,i)]));
        angle_of_attack(i,j) = real(rad2deg(acos(cos_angle(i,j))));
    end
end

full_fuel = size(dados.cg, 2);
phi_0 = 1;
for i = 1:length(mod_Vrocket)
    f = csapi(mod_Vwind, angle_of_attack(i,:));
    XCP0 = -M.XCP(phi_0, 1, :, full_fuel);
    f2 = csapi(dados.alpha, XCP0);
    
    max_aoa = angle_of_attack(end);
    n_max = true;

    for j = 1:length(mod_Vwind)
        alpha(j) = fnval(f, mod_Vwind(j));
        static_margin(i, j) = fnval(f2, alpha(j));
    end
end

figure
contourf(mod_Vwind, mod_Vrocket, static_margin)
colorbar
title('Launching Static Margin', 'Fontsize', 20, 'Interpreter','latex')
xlabel('$V_{WIND}$ (m/s)', 'Fontsize', 12, 'Interpreter','latex')
ylabel('$V_{ROCKET}$ (m/s)', 'Fontsize', 12, 'Interpreter','latex')

if savefigs
    file = ['Graphics/StaticMarginWind', datestr(clock,'YYYY_mm_dd'), '.png'];
    saveas(gcf, file);
end
