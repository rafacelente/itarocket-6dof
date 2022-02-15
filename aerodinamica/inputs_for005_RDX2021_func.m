function [for005] = inputs_for005_RDX2021_func(dref,L,Alt0,dados)
% Inputs do for005 foguete 2021/RDX

%% 1. Control Card
Inputfor005.CARD.DIM = 'M';
Inputfor005.CARD.DERIV = 'RAD';
Inputfor005.CARD.hasDAMP = 1;
Inputfor005.CARD.hasPRINTAEROHINGE = 1;
Inputfor005.CARD.hasSAVE = 1;
Inputfor005.CARD.hasNEXTCASE = 1;

for005.CARD = Inputfor005.CARD;

%% 2. $REFQ: Reference Quantities
% DADOS INPUT como Diametro do foguete e Comprimento total

Inputfor005.REFQ.hasLREF = 1;
if Inputfor005.REFQ.hasLREF == 1
    for005.REFQ.LREF = dref;
end

Inputfor005.REFQ.hasSREF = 1;
if Inputfor005.REFQ.hasSREF == 1
    for005.REFQ.SREF = pi*(for005.REFQ.LREF/2)^2;
end

Inputfor005.REFQ.XCG = 1.416;

Inputfor005.REFQ.hasSCALE = 0;
if Inputfor005.REFQ.hasSCALE ==1
    Inputfor005.REFQ.SCALE = 1;
    for005.REFQ.SCALE = Inputfor005.REFQ.SCALE;
end

Inputfor005.REFQ.hasBLAYER = 1;
if Inputfor005.REFQ.hasBLAYER ==1
    Inputfor005.REFQ.BLAYER = 'TURB';
    for005.REFQ.BLAYER = Inputfor005.REFQ.BLAYER;
end
for005.REFQ.hasLREF = Inputfor005.REFQ.hasLREF;
for005.REFQ.hasSREF = Inputfor005.REFQ.hasSREF;
for005.REFQ.XCG = Inputfor005.REFQ.XCG;
for005.REFQ.hasSCALE = Inputfor005.REFQ.hasSCALE;
for005.REFQ.hasBLAYER = Inputfor005.REFQ.hasBLAYER;

%% 3. $AXIBOD: Axisymmetric Body Geometry
Inputfor005.AXIBOD.option = 2;

if Inputfor005.AXIBOD.option == 1
        Inputfor005.AXIBOD.TNOSE = 'OGIVE';
        Inputfor005.AXIBOD.LNOSE = 0.0735;
        Inputfor005.AXIBOD.DNOSE = 0.147;
        Inputfor005.AXIBOD.BNOSE=0.0735;
        Inputfor005.AXIBOD.LCENTR=2.094;
        Inputfor005.AXIBOD.DEXIT=0.;
else
     Body.DiametroBody = dref;       % unidade metros
Body.Ltotal = L;                % unidade metros 2237; % sem bocal do motor

InputBody.Tipo = 1;                     % Tipo de geometria da coifa (Tipo 1: Elipsoide, Tipo 2: Ogiva)
InputBody.fineness = 2.5;               % Fineness ratio da coifa (razao entre comprimento e Diametro)
  
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
    BodyRocket = Gera_BodyRocket(InputBody,Body);
    
    Inputfor005.AXIBOD.NX = length(BodyRocket.X);
    Inputfor005.AXIBOD.X = BodyRocket.X; %.7f
    Inputfor005.AXIBOD.R = BodyRocket.R; %.6f
    Inputfor005.AXIBOD.DISCON = BodyRocket.DISCON;
    Inputfor005.AXIBOD.DEXIT=0.;
    
end

for005.AXIBOD = Inputfor005.AXIBOD;

%% 4. $FINSETN: Fin descriptions by fin set N
% se possue..
Inputfor005.FINSET1.has = 1; % empenas
Inputfor005.FINSET2.has = 0; % canares e empenas

if Inputfor005.FINSET1.has == 1 % se possue canares
	Inputfor005.FINSET1.hasZUPPER = 1;
    Inputfor005.FINSET1.hasLMAXU = 1;
    Inputfor005.FINSET1.hasLFLATU = 1;
    Inputfor005.FINSET1.hasLER = 1;
    
    Inputfor005.FINSET1.hasPHIF = 1;
    Inputfor005.FINSET1.hasCFOC = 1;
    Inputfor005.FINSET1.CFOC = [1,1,1];
    Inputfor005.FINSET1.NPANEL = 4;                  % ## INPUT ## Numero de empenas
    Inputfor005.FINSET1.AngleSET = [45,135,225,315];      % ## INPUT ## Posicao das empenas na saia do foguete
    
    InputEmpenas.SPAN = dados.fin_size/1000; % ## INPUT ## Semi envergadura da Empena, em (m)
    InputEmpenas.subsonico = true;                           % ## INPUT ##  VOO subsonico.
    InputEmpenas.e = 4/1000;
    InputEmpenas.Folga_TE_Saia = 0;                           % ## INPUT ## espaço entre o bordo de fuga das empenas e do Final da saia.
    % --- IMPORTANTE!
    % SE QUISER DEIXAR SEMPRE COMO RETO (2:1:1) a opcao abaixo
    % exclui parametros que virão logo a seguir.
    InputEmpenas.TrapReto211 = true; % ## INPUT ## OPCIONAL Pra mudar
    
    InputEmpenas.L = Body.Ltotal/1;           % # Comprimento total do foguete, desconsiderando o bocal do motor, se ele ficar pra fora
    InputEmpenas.R = Body.DiametroBody/2;                  % # Raio do corpo do foguete (raio externo)-> onde serao fixado as empenas

    if InputEmpenas.TrapReto211==false
        % SE NAO QUISER deixar Obrigatoriamente como geometria 2:1:1 RETO,
        % Mudar as opcoes abaixo:
        InputEmpenas.CordaRaiz = 300/1000;        % ## INPUT_opcional ## Comprimento da corda na raiz (root) da empena, em (m)
        InputEmpenas.AlphaAT = 30;                % ## INPUT_opcional ## Angulo de "entrada", no bordo de ataque, do perfil da empena.
        InputEmpenas.BetaSaida = 60;              % ## INPUT_opcional ## Angulo de "saida", no bordo de fuga, no perfil da empena.
    end
    InputEmpenas.Meio_Ang_ATQ = 30; % Angulo que o chanfro do Leading EDGE faz com a linha da corda.
    
    [Inputfor005.FINSET1,OutEmpenas] = Gera_Empenas(Body,Inputfor005.FINSET1,InputEmpenas); % só possue empenas
    
end
if Inputfor005.FINSET2.has == 1 % se possue canares
   	for005.FINSET2.SSPAN = [0.0735,0.1535,0.1635,0.35];
    for005.FINSET2.CHORD=[0.7,0.6,0.4,0.2];
	for005.FINSET2.hasCFOC = 1;
    for005.FINSET2.CFOC = [0.,0.,0.,0.];
    for005.FINSET2.XLE =[1.36,1.46,1.66,1.86];
    for005.FINSET2.NPANEL = 4;
    for005.FINSET2.PHIF = [0,90,180,270];
end
for005.FINSET1 = Inputfor005.FINSET1 ;
for005.FINSET2 = Inputfor005.FINSET2 ;

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
Inputfor005.FLTCON.ALT = Alt0*ones(1,Inputfor005.FLTCON.NMACH);   %%% Conforme sim_completo

for005.FLTCON = Inputfor005.FLTCON;


end