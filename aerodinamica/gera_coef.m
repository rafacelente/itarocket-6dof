clear all
clc
close all


%% INPUTS do foguete - mudar para app depois

%geometria do foguete
%diâmetro de referência (m)
rocket.dref = 0.1524;
%comprimento do foguete (m)
rocket.L = 2.411;


%posição final e inicial do CG em relação ao nariz (m)
rocket.Lcgf =  1.57;
rocket.Lcg0 =  1.661;

% Tipo de geometria da coifa (Tipo 1: Elipsoide, Tipo 2: Ogiva)
rocket.tipo_coifa = 1;
% Fineness ratio da coifa (razao entre comprimento e Diametro)
rocket.fineness = 2.5;
%semienvergadura da empena (m)
rocket.semispan = 180/1000; 
rocket.fin_width = 4/1000; %mm de espessura
%inputs de condição de simulação

%altitude de lançamento (m)
dados.Alt0 = 1401;
% vetor de PHI que entra como "alternativa ao angulo BETA"
% obs* no codigo do peixoto a configuracao eh phi+Alpha_Total
% ao inves de "alpha+beta". Se quiserem mudar isso, mexer no simulink.
dados.phif = 0:15:360; %o que isso faz?

% decrescente!!!!
dados.cg = linspace(rocket.Lcgf,rocket.Lcg0,5);

dados.alpha = [-20.,-16.,-12.,-8.,-4.,-2.,0.,2.,4.,8.,12.,16.,20.];
dados.mach  = [0.06,0.09,0.1,0.2,0.3,0.35,0.4,0.6,0.7,0.8,0.95,1.1];


%%
% Construção do arquivo de entrada do DATCOM
[for005] = for005_builder(rocket, dados);

%% RODAR O  DATCOM  PARA A MVO, EXTRAINDO OS DADOS DELE E SALVANDO.
tic
[M]=DATCOM_TO_MVO(dados,for005);
tempo = toc
time = datestr(clock,'YYYY_mm_dd');
save(strcat('AED_TO_MVO_',time),'M','dados','for005')
