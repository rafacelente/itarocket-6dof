%%% ### CODIGO QUE GERA GEOMETRIA DO BODY PRO DATCOM --- ITA-ROCKET-DESIGN ###
function [OutputBody] = rocket_body_builder(InputBody,Body)
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
        %caso usado pela rocket no Montenegro-1
        npontos = 49;
        Diam_pol = Body.DiametroBody/(0.02544);
        [X,R] = nose_builder( InputBody.Tipo,npontos,Diam_pol,InputBody.fineness);
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
