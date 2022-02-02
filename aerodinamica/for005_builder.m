function [for005] = for005_builder(rocket, dados)
% Inputs do for005 foguete 2021/RDX

%% 1. Control Card
for005.CARD.DIM = 'M';
for005.CARD.DERIV = 'RAD';
for005.CARD.hasDAMP = 1;
for005.CARD.hasPRINTAEROHINGE = 1;
for005.CARD.hasSAVE = 1;
for005.CARD.hasNEXTCASE = 1;

%% 2. $REFQ: Reference Quantities
% DADOS INPUT como Diametro do foguete e Comprimento total

for005.REFQ.LREF = rocket.dref;
for005.REFQ.SREF = pi*(for005.REFQ.LREF/2)^2;
%o que deve vir aqui?
Inputfor005.REFQ.XCG = 1.416;
for005.REFQ.SCALE = 1;   %tamanho do modelo (para uso com túnel de vento)
for005.REFQ.BLAYER = 'TURB';
%necessários pro datcom?
for005.REFQ.hasLREF = 1;
for005.REFQ.hasSREF = 1;
for005.REFQ.hasSCALE = 0;
for005.REFQ.hasBLAYER = 1;

%% 3. $AXIBOD: Axisymmetric Body Geometry
for005.AXIBOD.option = 2;

if for005.AXIBOD.option == 1
    %números obsoletos! não sei o que cada um significa
    for005.AXIBOD.TNOSE = 'OGIVE';
    for005.AXIBOD.LNOSE = 0.0735;
    for005.AXIBOD.DNOSE = 0.147;
    for005.AXIBOD.BNOSE=0.0735;
    for005.AXIBOD.LCENTR=2.094;
    for005.AXIBOD.DEXIT=0.;
else
    Body.DiametroBody = rocket.dref;       % unidade metros
    Body.Ltotal = rocket.L;                % unidade metros 2237; % sem bocal do motor
    
    InputBody.Tipo = rocket.tipo_coifa;                     % Tipo de geometria da coifa (Tipo 1: Elipsoide, Tipo 2: Ogiva)
    InputBody.fineness = rocket.fineness;               % Fineness ratio da coifa (razao entre comprimento e Diametro)
    
    % Lembrar que no maximo serao 50 pontos... Então, De antemao...
    % Ha transicao no corpo principal
    % Digite:  0 (não ha Transicao), 1 (há 1 Transicao)
    InputBody.Transicao.has = 0;
    
    if InputBody.Transicao.has==1
        % Se Houver Transicao, PREENCHER OS DADOS abaixo!
        % Se não houver, ignore esse trecho
        % ------------------------------------------------------------------------
        % ######## --------------------------------------------------------------
        Body.Transicao.DiametroAntes = Body.DiametroBody;
        InputBody.Transicao.DiametroDepois = 0.179;    %% INPUT o novo diametro em metros (m)
        InputBody.Transicao.XIniTransicao = 1.78343;     %% INPUT o ponto em metros (m)
        InputBody.Transicao.ComprimentoTransicao = 0.02304;  %% INPUT o comprimento transicao metros no eixo X (m)
        
        % CODIGO automatico.
        % Fazendo as contas e Ajustando valores pro datcom ->
        Body.Transicao.Xinicioreal = InputBody.Transicao.XIniTransicao; % corrigindo pra metros
        Body.Transicao.Rinicial = Body.Transicao.DiametroAntes/2;
        Body.Transicao.Rfinal = InputBody.Transicao.DiametroDepois/2;
        Body.Transicao.XfinalDiamreal = Body.Transicao.Xinicioreal+InputBody.Transicao.ComprimentoTransicao;
        % ######## --------------------------------------------------------------
        %-------------------------------------------------------------------------
        
    end
    
    % Desenvolver -> ha bocal de saida do motor.. ver se isso interfere.
    InputBody.BocalMotor.has = 0; % Digite:  0 (não ha Bocal), 1 (há 1 Bocal)
    if InputBody.BocalMotor.has == 1
        % Se Houver BOCAL DE SAIDA DO MOTOR, PREENCHER OS DADOS abaixo!
        % Se não houver, ignore esse trecho
        InputBody.BocalMotor.DiamAlinhadoSaia = 0.056;  %% INPUT do novo diametro alinhado com a saia (m)
        InputBody.BocalMotor.DiamExitMotor = 0.076;  %76.80;    %% INPUT do novo diametro de saida (m)
        InputBody.BocalMotor.LengthVisivelBocal = 0.03294;   %% INPUT do novo comprimento do foguete (m)
        
    end
    BodyRocket = rocket_body_builder(InputBody,Body);
    
    for005.AXIBOD.NX = length(BodyRocket.X);
    for005.AXIBOD.X = BodyRocket.X; %.7f
    for005.AXIBOD.R = BodyRocket.R; %.6f
    for005.AXIBOD.DISCON = BodyRocket.DISCON;
    for005.AXIBOD.DEXIT=0.;

end
%% 4. $FINSETN: Fin descriptions by fin set N
% se possue..
for005.FINSET1.has = 1; % empenas
for005.FINSET2.has = 0; % canares

if for005.FINSET1.has == 1 % se possue empenas
	for005.FINSET1.hasZUPPER = 1;
    for005.FINSET1.hasLMAXU = 1;
    for005.FINSET1.hasLFLATU = 1;
    for005.FINSET1.hasLER = 1;
    
    for005.FINSET1.hasPHIF = 1;
    for005.FINSET1.hasCFOC = 1;
    for005.FINSET1.CFOC = [1,1,1];
    for005.FINSET1.NPANEL = 4;                  % ## INPUT ## Numero de empenas
    for005.FINSET1.AngleSET = [45,135,225,315];      % ## INPUT ## Posicao das empenas na saia do foguete
    
    InputEmpenas.SPAN = rocket.semispan; % ## INPUT ## Semi envergadura da Empena, em (m)
    InputEmpenas.subsonico = true;                           % ## INPUT ##  VOO subsonico.
    InputEmpenas.e = rocket.fin_width;
    InputEmpenas.Folga_TE_Saia = 0;                           % ## INPUT ## espaço entre o bordo de fuga das empenas e do Final da saia.
    
    
    InputEmpenas.L = Body.Ltotal/1;           % # Comprimento total do foguete, desconsiderando o bocal do motor, se ele ficar pra fora
    InputEmpenas.R = Body.DiametroBody/2;                  % # Raio do corpo do foguete (raio externo)-> onde serao fixado as empenas
    
    % --- IMPORTANTE!
    % SE QUISER DEIXAR SEMPRE COMO RETO (2:1:1) a opcao abaixo
    % exclui parametros que virão logo a seguir.
    InputEmpenas.TrapReto211 = true; % ## INPUT ## OPCIONAL Pra mudar
    if InputEmpenas.TrapReto211==false
        % SE NAO QUISER deixar Obrigatoriamente como geometria 2:1:1 RETO,
        % Mudar as opcoes abaixo:
        InputEmpenas.CordaRaiz = 300/1000;        % ## INPUT_opcional ## Comprimento da corda na raiz (root) da empena, em (m)
        InputEmpenas.AlphaAT = 30;                % ## INPUT_opcional ## Angulo de "entrada", no bordo de ataque, do perfil da empena.
        InputEmpenas.BetaSaida = 60;              % ## INPUT_opcional ## Angulo de "saida", no bordo de fuga, no perfil da empena.
    end
    %valor para a empena 211?
    InputEmpenas.Meio_Ang_ATQ = 30; % Angulo que o chanfro do Leading EDGE faz com a linha da corda.
    
    [for005.FINSET1,OutEmpenas] = fin_builder(for005.FINSET1,InputEmpenas); % só possue empenas
    
end
if for005.FINSET2.has == 1 % se possue canares
   	for005.FINSET2.SSPAN = [0.0735,0.1535,0.1635,0.35];
    for005.FINSET2.CHORD=[0.7,0.6,0.4,0.2];
	for005.FINSET2.hasCFOC = 1;
    for005.FINSET2.CFOC = [0.,0.,0.,0.];
    for005.FINSET2.XLE =[1.36,1.46,1.66,1.86];
    for005.FINSET2.NPANEL = 4;
    for005.FINSET2.PHIF = [0,90,180,270];
end
plot_geometria(for005,InputEmpenas,OutEmpenas)

%% 5. $DEFLCT: Panel incidence (deflection) values
Inputfor005.DEFLCT.hasDELTA1 = 1;
Inputfor005.DEFLCT.DELTA1 = [0,0,0,0];
Inputfor005.DEFLCT.hasDELTA2 = 0;
Inputfor005.DEFLCT.hasXHINGE = 1;
Inputfor005.DEFLCT.XHINGE = 2.342;

for005.DEFLCT = Inputfor005.DEFLCT;

%% 6. $FLTCON: Flight Conditions (Angles of attack, Altitudes, etc.)
Inputfor005.FLTCON.hasBETA = 0;
Inputfor005.FLTCON.BETA = -1;
Inputfor005.FLTCON.ALPHA = dados.alpha;
Inputfor005.FLTCON.MACH  = dados.mach;
Inputfor005.FLTCON.NALPHA = size(Inputfor005.FLTCON.ALPHA,2);
Inputfor005.FLTCON.NMACH = size(Inputfor005.FLTCON.MACH,2);
Inputfor005.FLTCON.ALT = dados.Alt0*ones(1,Inputfor005.FLTCON.NMACH);   %%% Conforme sim_completo

for005.FLTCON = Inputfor005.FLTCON;


end