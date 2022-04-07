clear all;
close all;
clc

%TODO:
%revisar struct D- muito grande, repetição de dados
%fazer GUI
%input e output por projetos (copiar input no output?)
%revisar cálculo de inércias
%fazer simulação 1D da rampa? melhorar formato de corte do empuxxo
%atualizar nomes dos arquivos
%facilitar obtenção de máximos, dados importantes
%.gitignore
%ativar MATLAB COmparison Tools e marcar arquivos binários p comparar slx
%README.md



%% INPUTS
empty_mass = 25.844;          %Massa vazia do foguete (kg)
rocket_length = 2.39;              %Comprimento total do foguete (m)
rocket_cg = 1.56;           %CG vazio do foguete em relação à coifa (m)

Dref = 0.1524;    %Diâmetro de referência (m)
prop_outer_radius = 70.2e-3;   %Raio externo do propelente (m)
prop_inner_radius = 0.005;   %Raio interno do propelente (m)
prop_burn_time = 7.31;      %Tempo de queima do motor (s)
prop_mass = 4.81;           %Massa de propelente (kg)
prop_length = 210e-3;         %Comprimento do propelente (m)
prop_cg = 2.153;             %CG do propelente em relação à coifa (m)
thrust_file = 'ENTRADAS/Empuxo_Montenegro_06_04_2022.txt';       %Arquivo com a curva de empuxo (s e N)


aerodynamic_matrix_filename = 'ENTRADAS/AED_TO_MVO_2022_03_22_19_12_20.mat'; %Arquivo com as matrizes aerodinâmicas

rail_length = 5.7;         %Comprimento da rampa (m)
rail_friction = 0.5;       %Coeficiente de atrito da rampa
rail_angle = 86;          %Ângulo da rampa em relação à horizontal (graus)
g = 9.797;              %Gravidade (m/s^2)
launch_altitude = 1401;     %Altitude de lançamento (m)

sim_time = 100;         %Tempo máximo de simulação (s)

%% Parâmetros do vento
% Autor: Mol(T19), Elite(T21) e Onze(T20)
% Parâmetros

wind.On = 0;        % 0 - Sem Vento, 1-Com Vento
wind.tipo = 3;      % 1 - Turbulence; 2 - Wind Shear; 3 - Wind Gust; 4 - Turbulence + Wind Gust

% Parâmetros do Modelo de Turbul�ncia Dryden

turb.windSpeedAt6m      = 5;
turb.windDirectionAt6m  = 0;     % degrees clockwise from north
turb.scaleLength        = 533.4; % [m] Modelo recomenda usar 1750 ft
turb.wingspan           = 1; % [m] Precisa ser alterado com base no missil  simulado. **
turb.sampleTime         = 0.001; % [s], COLOCAR TEMPO AMOSTRAL (sampletime ou passo: dt da simula��o) **
turb.randomSeeds        = 238745; % Semente aleat�ria, deve ser mudada durante simula��o Monte Carlo % pode ser alterada

% Par�metros do modelo de Cisalhamento
shear.windSpeedAt6m = 3;
shear.windDirectionAt6m = 270;

% Par�metros do modelo de Rajada

gust.length             = [120 120 80];    % Gust length [dx dy dz] [m]
gust.amplitude          = (5/1.7)*[randn() randn() randn()];         % Gust amplitude [ug vg wg] [m/s] based on "Assessment of Methodologies to Forecast Wind Gust Speed"

% Par�metros de Background Wind NED - Alterar se apropriado
wind.Xw=5; % ** pode ser alterado
wind.Vw=0; % ** pode ser alterado
wind.Zw=0; % ** poder ser alterado

%% Desvios
sigma.delta    = 1*pi/180*0;	% desvios de deflexão das empenas
sigma.CGx      = 0.01*0;         %desvios de cg em relação a X, uso na função tabmassa_updated
sigma.CGyz     = 0.001*0;       %desvios de cg em relação a YZ, uso na função tabmassa_updated
sigma.Tprop    = 0.2*0;        %erro de Tempo de propulsão
sigma.Imp      = 0.1*0;          %erro de Impulso
sigma.inercia  = 0.003*0;    %erro de inércia
sigma.forcaAED = 0.033*0;   %erro de força AED
sigma.MAED     = 0.05*0;        %erro de momento AED
sigma.rampa    = 2*pi/180*0;   %desvio do Angulo inicial

%onde é usado?
desv_emp.theta = .1*pi/180*0;   %bloco propulsão, cálculo de Fprop
desv_emp.phi = pi/2*0;          %bloco propulsão, cálculo de Fprop

% ###------- 5) DELTAS [INPUTS]-------------- ### %
%remover? M_aed já é 4D
D.dlt1 = normrnd(0,sigma.delta);
D.dlt2 = normrnd(0,sigma.delta);
D.dlt3 = normrnd(0,sigma.delta);
D.dlt4 = normrnd(0,sigma.delta);

% ###------- 6) ERROS [INPUTS]-------------- ### %

erro.Tprop = normrnd(1,sigma.Tprop);
erro.Imp = normrnd(1,sigma.Imp);
erro.IX = normrnd(1,sigma.inercia);
erro.IY = normrnd(1,sigma.inercia);
erro.IZ = normrnd(1,sigma.inercia);
erro.x = normrnd(1,sigma.forcaAED);
erro.y = normrnd(1,sigma.forcaAED);
erro.z = normrnd(1,sigma.forcaAED);
erro.L = normrnd(1,sigma.MAED);
erro.M = normrnd(1,sigma.MAED);
erro.N = normrnd(1,sigma.MAED);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NÃO MODIFICAR DEPOIS DESTA LINHA! (para simulação)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ###------- 3) Parâmetros constantes [INPUTS] -------------- ### %


%c.Linear = 1;
%c.configT = c.Linear;
%necessário? usar conversor do simulink
c.D2R = pi/180;                   % Constante graus -> rad
c.R2D = 1/c.D2R;                    % Constante rad -> graus
c.g = g;                     % gravidade [m/s^2]

% ###------- 4) Condições iniciais de voo [INPUTS] -------------- ### %

D.Alt0 = launch_altitude;                  % altitude inicial [m]
[~,c.vsom,~,c.rho] = atmosisa(D.Alt0);

D.Gama0 = normrnd(rail_angle,sigma.rampa)*c.D2R;            % Angulo inicial

D.p0 = 0*c.D2R;                     % velocidade angular
D.q0 = 0*c.D2R;                     %
D.r0 = 0*c.D2R;                     %

% atitude inicial
D.phi0 = 0;                       % roll, rolamento
D.theta0 = D.Gama0;               % pitch, elevação
D.psi0 = 0;                       % yaw, guinada
D.quat0 = angle2quat(D.psi0,D.theta0,D.phi0); %angle2quat(yaw, pitch, roll)
D.Kq = D.quat0(1);



% ###------- 7) Dados do foguete [INPUTS] -------------- ### %

D.Dref = Dref;        	% Diâmetro (m),Comprimento de referência
D.Sref = pi*D.Dref^2/4;     % área de refer�ncia
D.R = D.Dref/2;

% ###------- 8) Dados do propelente [INPUTS] -------------- ### %

% Todas as distâncias em relação a coifa

%%%% input PRP/INTEGRAÇÃO
prp.Rmaior = prop_outer_radius;     % Raio externo do propelente (m)
prp.Rmenor = prop_inner_radius;     % Raio interno do propelente (m)

prp.burntime = prop_burn_time; %

% de acordo com 'Empuxo_RDX_teorico', Tprop = 5.945s
prp.massa = prop_mass;        % massa do propelente (kg)
prp.length = prop_length;	% Comprimento do propelente (m)
prp.cg = prop_cg;         % cg do gr�o propelente em relação a coifa  %%%% input INTEGRAÇÃO

% ###------- 9) Dados de massa do foguete [INPUTS]  -------------- ### %

fog.massa = empty_mass;       % massa do foguete sem propelente (kg), Massa após a queima
fog.length = rocket_length;	% comprimento do foguete (m)
fog.cg = rocket_cg;         % cg vazio(final) em relação a coifa

%para que serve isso?
D.L = fog.length;
D.Tprop = prp.burntime;        % tempo de queima




%% [2] Cálculo da Massa, XCG e Inercia -------------- ### %
% medidas em relação a coifa para AED
% Ref. TG Peixoto

D.mf = fog.massa;
D.mprop = prp.massa;
D.m0 = prp.massa + D.mf;

D.xcg0 = (fog.cg*fog.massa+prp.cg*prp.massa)/D.m0;

D.xcgm = (fog.cg*fog.massa+prp.cg*prp.massa/2)/(D.m0-prp.massa/2);

D.xcgf = fog.cg;

D.ycg = 0;
D.zcg = 0;

D.CRM = [D.xcgf  0   0]' - 0*[D.Dref 0  0]';

% Cálculo das matrizes de inércia Ixx
D.Ix0 = D.m0*D.R^2/2;                   % Inércia Ixx0 (kg.m2)
D.Ixm = (D.m0-prp.massa/2)*D.R^2/2; 	% Inércia Ixxm (kg.m2)
D.Ixf = (D.mf)*D.R^2/2;                 % Inércia Ixxf (kg.m2)

% Cálculo de Iyy de cada subsistema em relação ao CG inicial
% Considere o cálculo do momento de inércia de um cilindro sólido
% com eixo no diâmetro em relação ao CG inicial
fog.Iy0 = (D.R^2/4 + fog.length^2/12 + (D.xcg0 - fog.cg)^2)*fog.massa;
prp.Iy0 = (D.R^2/4 + prp.length^2/12 + (D.xcg0 - prp.cg)^2)*prp.massa;
D.Iy0 = fog.Iy0 + prp.Iy0;

% Cálculo de Iyy de cada subsistema em relação ao CG médio em T.prop/2
% Considere o cálculo do momento de inércia de um cilindro sólido
% com eixo no diâmetro em relação ao CG médio
fog.Iym = (D.R^2/4 + fog.length^2/12 + (D.xcgm - fog.cg)^2)*fog.massa;
prp.Iym = (D.R^2/4 + prp.length^2/12 + (D.xcgm - prp.cg)^2)*prp.massa/2;
D.Iym = fog.Iym + prp.Iym;


% Cálculo de Iyy de cada subsistema em relação ao CG final
% Considere o cálculo do momento de inércia de um cilindro sólido
% com eixo no diâmetro em relação ao CG final
fog.Iyf = (D.R^2/4 + fog.length^2/12 + (D.xcgf - fog.cg)^2)*fog.massa;
D.Iyf = fog.Iyf;

D.I0 = [D.Ix0  0       0; ...
    0    D.Iy0   0; ...
    0    0      D.Iy0];

D.Im = [D.Ixm  0       0; ...
    0    D.Iym   0; ...
    0    0      D.Iym];


D.If = [D.Ixf  0       0; ...
    0    D.Iyf   0; ...
    0    0      D.Iyf];

%% [3] Carregar dados pré-processados

load(aerodynamic_matrix_filename);


% ###------- 2) dados para simulação de rampa [INPUTS] -------------- ### %
%mudar o nome, não é empuxo cortado
rmp.Empuxo_Cortado = thrust_file;      % Arquivo com o empuxo já cortado para o ínicio do movimento. O próprio programa irá cortar o empuxo de novo para o movimento após a rampa.
rmp.Ltrilho = rail_length;                                % tamanho_do_trilho
rmp.coef_atrito_da_rampa = rail_friction;                       % coeficiente_de_atrito_da_rampa

% ###------- 12) Tempo da simulação 6DOF [INPUTS] -------------- ### %
D.Tfim = sim_time;                     % Tempo de simulação [s]


%% [3] Simulação de rampa -------------- ### %

% obter a tabela CDXMach considerando 
% DELTA, PHI e ALPHA nulos, e XCG médio.
tabela_cd = zeros(length(dados.mach),2);
idelta = 1;     % delta(i) = 0
iphi = 1;       % phi=0
ialpha = 7;     % alpha = 0;
icg_medio = 3;  % size(cg) = 5 
for (imach = 1:length(dados.mach))
    tabela_cd(imach,1) = dados.mach(imach);
    % considerando deltas, phi e alphas nulos e cg médio
    tabela_cd(imach,2) = M.CD(iphi,imach,ialpha,icg_medio);
end
save ENTRADAS/Tabela_CDxMach.dat tabela_cd -ascii
rmp.CDvMach = 'ENTRADAS/Tabela_CDxMach.dat';                 % Tabela de CD por Mach para simulação em 2DOF da rampa.

% A função rampa devolve em (1) a velocidade de saída e em (2) a duração do movimento na rampa.
rmp.res = rampa_nathy(D,rmp,c);
Mach0 = rmp.res(1)/c.vsom;                                                  % velocidade de saída da rampa.
% Define a tabela de empuxo para a dinâmica após a rampa. Salva o arquivo com o nome anterior +  _cortado.dat.
rmp.Empuxo_6DOF = novoCortaEmpuxo_nathy(rmp.Empuxo_Cortado, rmp.res(2), D.Tprop, 1);      

D.U = Mach0*c.vsom;     % Velocidade inicial
c.q = 1/2*c.rho*(D.U)^2;	% Pressão dinâmica

% ###------- Carrega o arquivo Empuxo_6DOF -------------- ### %
%%% Carrega o arquivo Empuxo_6DOF %%%
D.Empuxo = load(rmp.Empuxo_6DOF); 

%clear sigma prp fog rmp mi cgi Mach0

% time = datestr(clock,'YYYY_mm_dd_HH_MM_SS');
% save(strcat('ENTRADAS/INPUTS_',time))     % última versão do dia 11/08/2021
%% [4] Simulação 6DOF -------------- ### %

% clear all;
% close all;
% clc
% load('ENTRADAS/INPUTS_2021_08_17_06_08_10.mat')

% simulação após saída da rampa
teste  = sim('SIM_6DOF.slx');
% simulink SIM_6DOF_completo.slx do TG do Peixoto alterado:
% - utiliza quatérnion
% - Os dados aerodinâmicos estão em uma struct M
%observações:
% - não utiliza a matriz do XCP
% - cg=cga é em relação a coifa
% - Inércia em relação ao CG
% - Mxyz = Maer

% Para análise dos gráficos resultantes da simulação com diferentes Tprop 
% strTprop = sprintf('%.3f',D.Tprop);
% strTprop = strrep(strTprop,'.','_');
% filename = strcat('Sim_Tprop',strTprop);
% save(filename)     % salvar o workspace resultante da simulação de acordo com o Tprop
% save('Sim_Tprop5945')     % salvar o workspace resultante da simulação com Tprop = 5.945 s
% save('Sim_Tprop5469')     % salvar o workspace resultante da simulação com Tprop = 5.469 s

fprintf("Apogeu: %f\n", abs(Xe.Data(end,3)) - D.Alt0); % Print do apogeu

