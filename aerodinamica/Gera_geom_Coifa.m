function [ X,R ] = Gera_geom_Coifa( Tipo,npontos,Diametro,fineness )
% GERA_GEOM_COIFA medidas em metros
%   Funcao que gera a coifa, dependendo de seu tipo
%   com a quantidade de pontos que foi fornecida.
    if(Tipo ==1)
        % Tipo =1  raio (pol) menor da Elipse (raio do foguete)
        b=(Diametro/2)*0.02544;
        % Diametro maior da Elipse (comprimento da coifa)
        a=fineness*b*2;
        
        % gerando os pontos
        X = linspace(0,a,npontos);
        R = b*(1-(X-a).^2/a^2).^(0.5);

        X=X';
        R=R';
        
    elseif (Tipo==2)
        % Digitar o Diametro da coifa
        D = Diametro*0.02544;

        % Digitar o comprimento da coifa
        h =D*fineness;

        % Relacao geometrica pra achar o raio da circferencia.
        R = h^2/D+D;

        % Ang entre hor e resultante
        gama = asin(h/R);

        % Vetor que varre angulos
        Ang0 = linspace(0,gama,49);

        X_1 = R*cos(Ang0);
        Y_1 = R*sin(Ang0);

        % Rotacao de angulos
        X_2 = -Y_1;
        Y_2 = X_1;

        X_2 = wrev(X_2);
        Y_2 = wrev(Y_2);

        % Angulos alinhados com a orientacao do DATCOM
        X_f = (X_2 +R*sin(gama));
        Y_f = (Y_2 - R*cos(gama));
        X = X_f';
        R = Y_f';
    else
        
    end
    
end

