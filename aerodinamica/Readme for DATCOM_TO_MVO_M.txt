Referências: 
AED-TO-MVO
Local: Ita Rocket Design/Mecânica de Voo/RDX/AED

AED-TO-MVO_V3
Local: Ita Rocket Design/Aerodinâmica/AED-TO-MVO-NEW

Geração dos dados aerodinâmicos para o foguete da Rocket

Gerar coeficientes para diferentes dados: [M]=DATCOM_TO_MVO_M(dados,for005);

entradas:
dados: diferentes condições como rodar o Datcom
for005: entradas para gerar o for005

funções: 
gera_for005(for005): gera o arquivo for005 com as entradas em for005
!Misdat.exe: executa o datcom através do for005
[Mach,Alpha,CN,CM,CA,CY,CLN,CLL,CL,...                                CD,XCP,CNA,CMA,CYB,CLNB,CLLB,CNQ,...
CMQ, CAQ, CNAD, CMAD,CYR,CLNR,CLLR,...
CYP, CLNP, CLLP,hinge]=
DATCOMreader('for006.dat',for005.FINSET1,for005.FINSET2): leitura do arquivo for006 para obtenção das informações da simulação do datcom

saída: 
M: struct com os coeficientes aerodinâmicos de acordo com a variação dos dados






saída:
M: struct com todas as matrizes de coeficientes para diferentes dados



