%% GERA OS COEFICIENTES AERODINÂMICOS PARA O RDX
% referência: gera_coef.m
% endereço:
% Ita Rocket
% Design/Mecânica de voo/RDX/AED/AED-TO-MVO


clear all
clc
close all

%%% dados do foguete RDX
dref = 0.1524;
L = 2.2803;
Alt0 = 1294;
%Alt0 = 0;
dlt1 = 0;
dlt2 = 0;
dlt3 = 0;
dlt4 = 0;
Lcgf =  1.4460;
Lcg0 =  1.5145;
% AED_TO_MVO_2021_09_04_17_45_48.mat (reduzido)
% tempo =
% 
%    2.1400e+03
% AED_TO_MVO_2021_09_11_15_08_23.mat (completo)
% tempo =
% 
%    2.1396e+03

%%% Entradas para a análise MVO


% vetor de PHI que entra como "alternativa ao angulo BETA"
% obs* no codigo do peixoto a configuracao eh phi+Alpha_Total
% ao inves de "alpha+beta". Se quiserem mudar isso, mexer no simulink.
dados.phif = 0:15:360;

dados.cg = linspace(Lcgf,Lcg0,5);

dados.alpha = [-20.,-16.,-12.,-8.,-4.,-2.,0.,2.,4.,8.,12.,16.,20.];
dados.mach  = [0.06,0.09,0.1,0.2,0.3,0.35,0.4,0.6,0.7,0.8,0.95,1.1];

% Entradas no FOR005

% % Inputs do for005 para foguete 2021/RDX em função de (dref,L,Alt0)
[for005] = inputs_for005_RDX2021_func(dref,L,Alt0,dados);



%% RODAR O  DATCOM  PARA A MVO, EXTRAINDO OS DADOS DELE E SALVANDO.
tic
[M]=DATCOM_TO_MVO_RDX2021(dados,for005);
tempo = toc
time = datestr(clock,'YYYY_mm_dd_HH_MM_SS');
save(strcat('AED_TO_MVO_',time),'M','dados','for005')

% tempo =
% 
%    2.8278e+04
% tempo =
% 
%    2.1818e+03
