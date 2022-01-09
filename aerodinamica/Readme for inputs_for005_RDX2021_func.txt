Referências: 
AED-TO-MVO
Local: Ita Rocket Design/Mecânica de Voo/RDX/AED

AED-TO-MVO_V3
Local: Ita Rocket Design/Aerodinâmica/AED-TO-MVO-NEW

Obtenção das entradas para a obtenção do arquivo for005

entradas:
dref:  Diâmetro do foguete (m)
L: Comprimento do foguete
Alt0: Altitude inicial do foguete

Definições necessárias: 
1. Inputfor005.CARD: Control Card
2. Inputfor005.REFQ: Reference Quantities
InputBody
3. Inputfor005.AXIBOD: Axisymmetric Body Geometry
InputBody
InputTransicao
InputBocalMotor
4. Inputfor005.FINSETN: Fin descriptions by fin set N
InputEmpenas
5. InputDEFLCT: Panel incidence (deflection) values
6. InputFLTCON: Flight Conditions (Angles of attack, Altitudes, etc.)

Ltotal: comprimento total
Tipo: tipo de coifa
fineness: razão entre comprimento e diâmetro da coifa
Transicao: há transição?
BocalMotor: há bocal de saída do motor?
Se houver transição:
	- DiametroDepois: o novo diametro (mm)
	- XIniTransicao: o ponto de início de transição (mm)
	- ComprimentoTransicao: comprimento transicao no eixo X (mm)

funções:
[OutputBody] = Gera_BodyRocket(InputBody,Body)
[X,R]=Gera_geom_Coifa( Tipo,npontos,Diametro,fineness )
empenas = Gera_Empenas(body,empenas,Inputs)


saída: 
for005
