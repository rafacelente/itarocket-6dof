%%% ### CODIGO QUE GERA GEOMETRIA DO BODY PRO DATCOM --- ITA-ROCKET-DESIGN ###
function [OutputBody] = Gera_BodyRocket(InputBody,Body)
% foguete 2021/RDX


% % DADOS INPUT como Diametro do foguete e Comprimento total
% body.DiametroBody = 152.4;       % unidade milimetros
% body.Ltotal = 2280.35;                % unidade milimetros 2237; % sem bocal do motor
% body.Tipo = 1;                     % Tipo de geometria da coifa (Tipo 1: Elipsoide, Tipo 2: Ogiva)
% body.fineness = 2.5;               % Fineness ratio da coifa (razao entre comprimento e Diametro)
% 
% 
% % Lembrar que no maximo serao 50 pontos... Então, De antemao...
% % Ha transicao no corpo principal
% % Digite:  0 (não ha Transicao), 1 (há 1 Transicao)
% Transicao.has = 0;
% 
% 
% % Desenvolver -> ha bocal de saida do motor.. ver se isso interfere.
% BocalMotor.has = 0; % Digite:  0 (não ha Bocal), 1 (há 1 Bocal)

% if BocalMotor.has == 1
%     % Se Houver BOCAL DE SAIDA DO MOTOR, PREENCHER OS DADOS abaixo!
%     % Se não houver, ignore esse trecho
%     BocalMotor.DiamAlinhadoSaia = 56;  %% INPUT do novo diametro alinhado com a saia (mm)
%     BocalMotor.DiamExitMotor = 76;  %76.80;    %% INPUT do novo diametro de saida (mm)
%     BocalMotor.LengthVisivelBocal = 32.94;   %% INPUT do novo comprimento do foguete (mm)
%     
% end
% 
% if Transicao.has==1
%     % Se Houver Transicao, PREENCHER OS DADOS abaixo!
%     % Se não houver, ignore esse trecho
%     % ------------------------------------------------------------------------
%     % ######## --------------------------------------------------------------
%     Transicao.DiametroAntes = body.DiametroBody;
%     Transicao.DiametroDepois = 179.00;    %% INPUT o novo diametro em milimetros (mm)
%     
%     Transicao.XIniTransicao = 1783.43;     %% INPUT o ponto em milimetros (mm)
%     Transicao.ComprimentoTransicao = 23.04;  %% INPUT o comprimento transicao milimetros no eixo X (mm)
%     
%     
%     % CODIGO automatico.
%     % Fazendo as contas e Ajustando valores pro datcom ->
%     Transicao.Xinicioreal = Transicao.XIniTransicao/1000; % corrigindo pra metros
%     Transicao.Rinicial = Transicao.DiametroAntes/2000;
%     Transicao.Rfinal = Transicao.DiametroDepois/2000;
%     Transicao.XfinalDiamreal = Transicao.Xinicioreal+Transicao.ComprimentoTransicao/1000;
%     % ######## --------------------------------------------------------------
%     %-------------------------------------------------------------------------
%     
% end


% Validando a transicao e motor do Foguete.
if(InputBody.Transicao.has ==0)
    if(InputBody.BocalMotor.has==1)
        npontos = 47;
        Diam_pol = Body.DiametroBody/(25.44);
        [X,R] = Gera_geom_Coifa( InputBody.Tipo,npontos,Diam_pol,InputBody.fineness);
        X(48) = Body.Ltotal;
        R(48) = Body.DiametroBody/2;
        X(49) = Body.Ltotal;
        R(49) = InputBody.BocalMotor.DiamAlinhadoSaia/2;
        X(50) = X(49)+InputBody.BocalMotor.LengthVisivelBocal/1;
        R(50) = InputBody.BocalMotor.DiamExitMotor/2;
        DISC = [48,49,50];
    else
        npontos = 49;
        Diam_pol = Body.DiametroBody/(0.02544);
        [X,R] = Gera_geom_Coifa( InputBody.Tipo,npontos,Diam_pol,InputBody.fineness);
        X(50) = Body.Ltotal;            % posicao final (x) da geometria do corpo
        R(50) = Body.DiametroBody/2;      % Posicao final (R) da geometria do corpo
        % Nesse caso ha apenas 1 ponto de descontinuidade, que é o ultimo
        DISC = 50;
    end
elseif(InputBody.Transicao.has==1)
    if(InputBody.BocalMotor.has==1)
        npontos = 45;
        Diam_pol = Body.DiametroBody/(25.44);
        [X,R] = Gera_geom_Coifa( InputBody.Tipo,npontos,Diam_pol,InputBody.fineness);
        X(46) = Body.Transicao.Xinicioreal; % antes da transicao
        R(46) = Body.Transicao.Rinicial;    % antes da transicao
        X(47) = Body.Transicao.XfinalDiamreal;  % dps da transicao
        R(47) = Body.Transicao.Rfinal;          % dps da transicao
        X(48) = Body.Ltotal;     % comprimento final da saia
        R(48) = Body.Transicao.Rfinal;          % diametro final da saia
        X(49) = X(48);           % posicao onde começa o bocal do motor
        R(49) = InputBody.BocalMotor.DiamAlinhadoSaia/2; % tamanho do bocal alinhado
        X(50) = X(49)+InputBody.BocalMotor.LengthVisivelBocal/1;  % posicao final do bocal
        R(50) = InputBody.BocalMotor.DiamExitMotor/2;             % tamanho final do raio de saida do motor.
        DISC = [46,47,48, 49, 50];
    else
        npontos=47;
        Diam_pol = Body.DiametroBody/(25.44);
        [X,R] = Gera_geom_Coifa( InputBody.Tipo,npontos,Diam_pol,InputBody.fineness);
        X(48) = Body.Transicao.Xinicioreal;
        R(48) = Body.Transicao.Rinicial;
        X(49) = Body.Transicao.XfinalDiamreal;
        R(49) = Body.Transicao.Rfinal;
        X(50) = Body.Ltotal;
        R(50) = Body.Transicao.Rfinal;
        DISC = [48, 49, 50];
    end
else
    display('ha pelo menos 2 transicoes ou deu erro nisso ai!');
    
end


OutputBody.X = X;
OutputBody.R = R;
OutputBody.DISCON = DISC;

end
