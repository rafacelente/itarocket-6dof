function [empenas,Outs] = Gera_Empenas(Body,empenas,Inputs)
% Para qualquer empena
%%%%% ### CODIGO QUE GERA GEOMETRIA DO BODY PRO DATCOM --- ITA-ROCKET-DESIGN ###
%   ELE CONSTROI A GEOMETRIA DAS EMPENAS SEGUNDO AS FORMULAS DO MANUAL DO
%   DATCOM E AS INSERE NO ARQUIVO DE ENTRADA FOR005.DAT   
% -------------------------------------------------------------------------------


% Para mais detalhes, leia a partir da pagina 47 do manual do DATCOM, ou
% consulte o arquivo GEOMETRIA_FOGUETE.xls.. que organiza as tabelas e
% figuras do DATCOM

% ##### INPUT MANUAL -> Entradas ####

 % ##### INPUT MANUAL -> Entradas ####
    % GEOMETRIA UTILIZADA- FOGUETE


    % obs* (criar um switch case para outras geometrias no futuro)



% GEOMETRIA DA EMPENA   -> Havera uma definicao padrao de reto 2:1:1. no
% codigo, mas ela podera ser alterada logo abaixo.
% 

%      ----------                /\
%    /            \              ||
%   /              \            SPAN
%  /                \            ||
% / $-> Alpha        \ $-> Beta  ||
% --------------------           \/
% <---- CHORDroot ---->


%-----------------------------------------------------------------------------------

% ### ETAPA DE CALCULOS %%

% AS contas serão FEITAS considerando um perfil de empenas do modelo hexagonal simetrico
% conforme feito no DATCOM (HEX), na Página 45.

if(Inputs.TrapReto211)
    Outs.AlphaAT = 45;
    Outs.BetaSaida = 90;
    % Posicao radial das cordas (Semi-spans)
    empenas.SSPAN =   [Inputs.R ; Inputs.R+Inputs.SPAN];
    % Cordas maior e menor da empena, nas estações (spans)
    Outs.x1 = Inputs.SPAN/(tand(45)); % ponto inicio Ctip na distancia SPAN
    x2 = 2*Inputs.SPAN;          % projecao reta bordofuga na distancia SPAN
    Outs.Ctip =  x2-Outs.x1;
    Outs.CordaRaiz = 2*Inputs.SPAN;
    empenas.CHORD =   [Outs.CordaRaiz; Outs.Ctip];
    XLE1 = Inputs.L-Inputs.Folga_TE_Saia-Outs.CordaRaiz;
    empenas.XLE = XLE1+[0;Outs.x1];
else
    % Caso a geometria nao seja obrigatoriamente Trapezoidal 2:1:1
    empenas.SSPAN =  [Inputs.R ; Inputs.R+Inputs.SPAN];
    % Cordas maior e menor da empena, nas estações (spans)
    Outs.x1 = Inputs.SPAN/(tand(Inputs.AlphaAT)); % projecao inicio CORDATIP na distancia SPAN
    if(Inputs.BetaSaida==90)
       x2 = Outs.CordaRaiz; 
    else
       x2 = Inputs.SPAN/(tand(Inputs.BetaSaida))+Inputs.CordaRaiz; % projecao final CORDATIP na distancia SPAN
    end  
    Outs.Ctip =  x2-Outs.x1;
    empenas.CHORD =   [Outs.CordaRaiz ; Outs.Ctip];
    XLE1 = Inputs.L-Inputs.Folga_TE_Saia-empenas.CHORD(1);
    empenas.XLE = XLE1+[0;Outs.x1];
end



% #### Parametros Relevantes da empena no formato HEX. ####

% Thickness to chord ratio of upper surface. Input separado for each span station, ou seja, cordas.
% Consideraremos que a espessura da empena seja a mesma nas duas estaçoes de SPAN
% No Manual, o ZLOWER default é igual ao ZUPPER, mas pra obter Zupper, faz
% sentido pegar apenas metade da espessura, senão não haveria critério pra ser diferente.

empenas.ZUPPER = [(Inputs.e/(empenas.CHORD(1)))/2;(Inputs.e/(empenas.CHORD(2)))/2];
    
% Inputs.Meio_Ang_ATQ = 30; % Angulo que o chanfro do Leading EDGE faz com a linha da corda.

% Ponto, medido em FRAÇÃO da corda, em que ocorre a espessura maxima da empena na geometria HEX. 
% (pag 44. do DATCOM)
if Inputs.subsonico
    empenas.LMAXU = [((Inputs.e/2)*tand(90-Inputs.Meio_Ang_ATQ))/empenas.CHORD(1);((Inputs.e/2)*tand(90-Inputs.Meio_Ang_ATQ))/empenas.CHORD(2)];
else
    empenas.LMAXU = [((Inputs.e/2)*tand(90-Inputs.Meio_Ang_ATQ))/empenas.CHORD(1);((Inputs.e/2)*tand(90-Inputs.Meio_Ang_ATQ))/empenas.CHORD(2)];
end

% Fracao da corda que a geometria do perfil será reta, considerando a seçao HEX (simetrica)
if Inputs.subsonico
    empenas.LFLATU = [(empenas.CHORD(1)-2*((Inputs.e/2)*tand(90-Inputs.Meio_Ang_ATQ)))/empenas.CHORD(1) ;(empenas.CHORD(2)-2*((Inputs.e/2)*tand(90-Inputs.Meio_Ang_ATQ)))/empenas.CHORD(2)];
else % Supersonico
    empenas.LFLATU = [(empenas.CHORD(1)-2*((Inputs.e/2)*tand(90-Inputs.Meio_Ang_ATQ)))/empenas.CHORD(1) ;(empenas.CHORD(2)-2*((Inputs.e/2)*tand(90-Inputs.Meio_Ang_ATQ)))/empenas.CHORD(2)];
end


% Leading Edge Radius (arredondamento do bordo de ataque, bizu para subsonico)
if Inputs.subsonico
    empenas.LER = [Inputs.e/5 ; Inputs.e/5]; % carteei um raio menor que a metade da espessura, mas não tanto
else
    empenas.LER = [0 ; 0];
end



end
