function [saida] = rampa_nathy(D,rmp,c)
    % (D.m, D.mf, D.dref, Ltrilho, D.Gama0, Empuxo_Cortado, CDvMach, D.Alt0, coef_atrito_da_rampa)
    % Autor: Rafael (T23)
    
    %%%%%%% MASSA E TAMANHOS %%%%%%%%%%%%%%%%%%%%%
    massa_inicial = D.m0;               % em kg foguete cheio, massa inicial 
    massa_final = D.mf;                 % em kg
    tamanho_do_trilho = rmp.Ltrilho;    % em metros
    angulo_de_lancamento = D.Gama0;     % em graus
    A = D.Sref;                         % em m^2, área de referência 
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%% PROPULSÃO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    arquivo_empuxo = rmp.Empuxo_Cortado;
    curva_de_empuxo = load(arquivo_empuxo);
    tempo_de_queima = curva_de_empuxo(end,1);
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%% AERODINÂMICA %%%%%%%%%%%%%%%%%%%%%%%%%%%
    arquivo_CD = rmp.CDvMach;
    if (ischar(arquivo_CD))
        tabela_CD = load(arquivo_CD);
    else
        tabela_CD = arquivo_CD;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    %%%%%% OUTROS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    altitude_de_lancamento = D.Alt0;
    coeficiente_de_atrito_da_rampa = rmp.coef_atrito_da_rampa;
	atmDensity = c.rho; % Densidade atmosférica a 35 graus. Não muda muito o resultado fazer ele ser variável.
    ThrustFunction = csapi(curva_de_empuxo(:,1), curva_de_empuxo(:,2)); % Criação de funçoes em cima das tabelas dadas
    if (ischar(arquivo_CD))
        CDFunction = csapi(tabela_CD(:,1), tabela_CD(:,2));  
    else
        CDFunction = tabela_CD;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tspan = [0;D.Tfim];
    options = odeset('Events', @events);
    [T,X] = ode45(@(T,X) rail_dynamics(T, X, ThrustFunction, CDFunction, ...
        A, [massa_inicial; massa_final; tempo_de_queima], ...
        coeficiente_de_atrito_da_rampa, angulo_de_lancamento, atmDensity, ...
        c.g, altitude_de_lancamento), tspan, [0;0.01], options);
        
    %fprintf("Time ended: %f\n", T(end));
    %fprintf("Velocity: %f\n", X(end));

    saida = [X(end), T(end)]; % Os resultados são retornados na forma de 
                              % vetor. A velocidade final é o saida(1) e 
                              % o tempo total é saida(2).

end

%% Função da dinâmica do movimento do foguete do trilho. %
function [X_p] = rail_dynamics(time, X, ThrustFunction, CDFunction, A, MassVec, coeficiente_de_atrito_da_rampa, angulo_de_lancamento, atmDensity, g, altitude_de_lancamento)
    
    x = X(1); % XtThrust é o vetor de caracteristica do movimento, guardando a posição em relação ao trilho em (1)
    v = X(2); % e a velocidade em (2)
    
    Thrust = ThrustAt(ThrustFunction, time);
    CD = CdAt(CDFunction, v, altitude_de_lancamento);     % Essas funções são look-up tables para pegar os valores de Empuxo, CD e massa
    mass = MassAt(MassVec(1), MassVec(2), MassVec(3), time);            % nas condições de voo no momento.

    % Vetor de derivadas. A expressão é gerada da dinâmica do voo na rampa considerando atrito e ângulo constante.
    [X_p] = [v; (Thrust - 0.5*atmDensity*CD*A*v^2)/mass - (coeficiente_de_atrito_da_rampa*cos(angulo_de_lancamento*pi/180) + sin(angulo_de_lancamento*pi/180))*g]; 

end
%%

%% Funcao para determinar ponto em que o integrador deve parar. Nesse caso,
% quando a distância percorrida for maior do que o tamanho do trilho.
function [check, isterminal, direction] = events(time, X,tamanho_do_trilho)
direction = [ ];
isterminal = 1;
check = double( X(1) > 5.284 );
% tamanho da rampa = 5.284m;
end
%%

%% Look-up table para a curva de empuxo
function T = ThrustAt(ThrustFunction, time)
    T = fnval(time, ThrustFunction);
    % retorna o valor do empuxo no instante "time"
end
%%

%% Look-up table para a tabela de CDxMach
function CD = CdAt(CDFunction, v, h)
    vmach = v/(340.294 - 3.83212e-3.*h - 2.40784e-8.*h.^2);
    CD = fnval(vmach, CDFunction);
    % retorna o valor do CD na velocidade "vmach"
end
%%

%% Equação linear para variação de massa
function mass = MassAt(mi, mf, tempo_de_queima, t)
        mass = mi - (mi-mf)*t/tempo_de_queima;
end
%%











