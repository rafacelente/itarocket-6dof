Nathália Matos
Data:06/09/2021

Sim_completo_RDX_q.m:
código principal da Simulação 6DOF para RDX2021
% referência: 
% Sim_completo git hut download feito em 05/05/2021

SIM_6DOF_completo_qnathy.slx:
% simulink SIM_6DOF_completo.slx do github alterado:
% - utiliza quatérnion
% - Os dados aerodinâmicos estão em uma struct M
% - não utiliza a matriz do XCP pois é desnecessária
% observações:
% - cg é em relação a tubeira
% - cga é em relação a coifa
% - Mxyz = Maer+Mprop


Sim_completo_RDX_q_comparaPeixoto.m:
% código principal da Simulação 6DOF para RDX2021
% referências:
% Sim_completo git hut data 05/05/2021
% TG peixoto
[Recomendo utilizar este para simulação]


SIM_6DOF_completo_qnathy_comparaPeixoto.slx:
% simulink SIM_6DOF_completo.slx do TG do Peixoto alterado:
% - utiliza quatérnion
% - Os dados aerodinâmicos estão em uma struct M
%observações:
% - não utiliza a matriz do XCP
% - cg=cga é em relação a coifa
% - Inércia em relação ao CG
% - Mxyz = Maer


novoCortaEmpuxo_nathy.m:
Alterado pois tive que zerar o empuxo após o tempo de queima. Fiz mais comentários

plotmissil.m: não fiz alterações

rampa_nathy.m:
[saida] = rampa_nathy(D,rmp,c)

Não alterei a lógica. Apenas fiz uma organização de argumentos de acordo com as funções principais em relação a função original rampa.m. 

Ref Git Hub:
pasta com os arquivos extraídos do github e utilizados como referência


LASC_Images:
pasta com imagens salvas do plotmissil.m

ENTRADAS:
pasta com os arquivos de entrada utilizados pelos códigos principais






