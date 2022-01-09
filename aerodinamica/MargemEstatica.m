%% PREVISOES DE MARGEM ESTATICA NO PROGRESSO DE VOO --> Cálculos

% ESSE SCRIPT Só funciona se:

% [1] o codigo DATCOMio.m ser rodado anteriormente, na abertura do Matlab


Lref = 0.152; % INPUT ##


% Calculando velocidade do som
% Simplificar a Temperatura como invariante na altura da Atmosfera.
gamma = 1.4;
R = 287;
a = sqrt(gamma*R*(T+273.15));


% Vetor de velocidades para tirar AoA (angulo de ataque)
v=Mach*a;               % Mach eh o output do DATCOM onde v(1) eh Vsaida_rampa


MaxVento = 15;          % Velocidade MAXIMA do vento em truth or consequences.

Vsaidarampa = v(1);     % menor velocidade do datcom EH pra ser a velocidade do lançamento da saida de rampa 
                        % Conferir na simulacao de AED. Se nao for,
                        % substituir essa variavel por velocidade na saida
                        % de rampa.
                        
ang_lanc = deg2rad(6);  % ANGULO DE LANCAMENTO DO FOGUETE(5º No NOVO SIST REFERENCIA ABAIXO);

ang_vento = deg2rad(90);% ANGULO DO VENTO, EM RELACAO AO SIST DE REFERENCIA NOVO. 

IterV = 197;            % Discretizacao do vento.
IterV2 = 14;            % Discretizacao da velocidade.


%% ORIENTACAO EIXOS (2-D) NORTE X(+), ESQUERDA, Y(+). Considerar o Vento 


Mod_Vvento = linspace(0,MaxVento,IterV);          % Vetor contendo a velocidade do vento
                                              % Cuidado na hora de aumentar acima de 10, pois
                                              % pode prejudicar a visualização nos gráficos a
                                              % seguir.

 
MinR = Vsaidarampa-4; % SE QUISER MUDAR O MINIMO Vrocket lançamento.
MaxR = Vsaidarampa+6; % SE QUISER MUDAR O MAXIMO Vrocket lançamento.

Mod_Vfoguete = linspace(MinR,MaxR,IterV2);       %Modulo da velocidade do foguete, no intervalo acima.


%% Inicializar as Variaveis pra ficar mais rapido as contas
Vfoguete(2,length(Mod_Vfoguete))=0; Vvento(2,length(Mod_Vvento))=0; Vtotal(2,length(Mod_Vvento))=0; cos_angulo(length(Mod_Vfoguete),length(Mod_Vvento))=0;
angulo_ataque(length(Mod_Vfoguete),length(Mod_Vvento))=0;   Alphanew(length(Mod_Vvento))=0; XCPreal(length(Mod_Vfoguete),length(Mod_Vvento))=0;

for(p=1:length(Mod_Vfoguete))
   Vfoguete(1,p) = Mod_Vfoguete(p)*cos(ang_lanc); 
   Vfoguete(2,p) = Mod_Vfoguete(p)*sin(ang_lanc);
end

%%  Contas e Resultados..

for(k=1:length(Mod_Vfoguete))   % dentro de cada uma das velocidades do foguete, fazer essas contas com o vento associado!
    for(i=1:length(Mod_Vvento))
        Vvento(1,i) = [Mod_Vvento(i)*cos(ang_vento)];   % criando um vetor de velocidades Vvento
        Vvento(2,i) = [Mod_Vvento(i)*sin(ang_vento)];   % Isso é um vetor cujos elementos sao velocidades em duas dimensoes. Matlab
                                                        % Isso traduz numa
                                                        % matriz.                      

        Vtotal(1,i) = Vfoguete(1,k)+Vvento(1,i);        % Vetor de vetores velocidades TOTAIS (Vvento + Vfoguete) vetorial.
        Vtotal(2,i) = Vfoguete(2,k)+Vvento(2,i);        % Velocidade total do foguete, para cada Vfoguete (em k)

        cos_angulo(k,i) = dot([Vfoguete(1,k);Vfoguete(2,k)],[Vtotal(1,i);Vtotal(2,i)])/(norm([Vfoguete(1,k);Vfoguete(2,k)])*norm([Vtotal(1,i);Vtotal(2,i)])); 
        angulo_ataque(k,i) = real(rad2deg(acos(cos_angulo(k,i)))); % Angulo de ataque efetivo, considerando o vento para cada velocidade do foguete
                                                                   % e para cada vento.
    end
     
    
end


MatrizX = angulo_ataque; % Logo, MX eh uma matriz de 2-D de 14x197.

MatrizY = Mod_Vvento;    % Ypoints MY eh uma matriz 2-D de 14x197.
                        
% Para cada velocidade do foguete e para
% cada angulo de ataque obtido, existe uma relacao com a velocidade do vento, na mesma ORDEM

for(k=1:length(Mod_Vfoguete))
    Xpoints = MatrizX(k,:);
    Ypoints = MatrizY;
    
    % cria uma relacao, interpolacao de Y e X 
    % necessidade de ter um vento pra dps um angulo de ataque associado
    f = csapi(Ypoints,Xpoints);
    
    
    % Fazer um PolyVal com O XCP em ME e Alpha
    
    % Consideracoes. Variacao de Velocidade no lancamento nao afeta
    % o Mach 0.08 do datcom pra extrair o XCP. (vou considerar cte 0.08)
    
    % Para os mais CANCERES.. fazer uma rotina nesse script que execute o Datcom 
    % e altere o MACH (1) de acordo com a variacao da velocidade de saida
    % da rampa.. 
    
    % Considerar o XCP em mach 0.08, motor carregado e sem derrapagem.
    XCP0 = -M.XCP(:,1,length(XCG),simetrico);
    f2 = csapi(Alpha,XCP0);
    % Agora ha uma relacao de Alpha e XCP, onde alpha eh X e Y

    
    % Maximo angulo de ataque do vento.
    Max_A0A = Xpoints(end);
    % Variavel booleana que indica se estoura o max A0A
    Nmaximo = true; 
    
    for(i=1:length(Mod_Vvento))
        % para cada um dos valores de vento, pegar o Alpha correspondente
        Alphanew(i) = fnval(f,Mod_Vvento(i));
        % para cada um dos alpha, pegar o XCP correspondente
        XCPreal(k,i) = fnval(f2,Alphanew(i));
       
    end
 
end

%% Grafico de margem estatica no lancamento
figure
contourf(Mod_Vvento,Mod_Vfoguete,XCPreal)
colorbar
title('Launching Static Margin', 'Fontsize', 20)
xlabel('V_{WIND} (m/s)', 'Fontsize', 20)
ylabel('V_{ROCKET} (m/s)', 'Fontsize', 20)

 

 %% ### PASSEIO DA MARGEM ESTATICA ### %% considerando A0A = 0 e BETA = 0.

XCPME = -M_XCP;
indicemenoscheio = length(XCG)-1;

 XCPcheio = XCPME(1,:,length(XCG),simetrico);
 XCPmenoscheio = XCPME(1,:,indicemenoscheio,simetrico);
 XCPquasevazio = XCPME(1,:,3,simetrico); 
 XCPvazio = XCPME(1,:,1,simetrico);
 
 
 figure;
 plot(Mach,XCPvazio,'*-',Mach,XCPcheio,'r*-',Mach,XCPmenoscheio,'g*-',Mach, XCPquasevazio,'y*-');
 legend('Empty fuel','Full fuel','with 60% fuel','with 20% fuel');
 xlabel('Mach');
 ylabel('Static Margin');
 title('flight with A0A = 0');
 hold on;
 grid on;

 
% Plot grafico XCP, considerando a partir do vazio
X_cpreal = XCPvazio*Lref+XCG(1); % casado os dados dele vazio
X_cprealn = X_cpreal';

X_cpreal2 = XCPcheio*Lref+XCG(end); % casado os dados dele vazio

Passeio2CG = linspace(XCG(1),XCG(1)+120/1000,100);
Passeio3CG = linspace(XCG(end),XCG(end)+120/1000,100);
PassioMEvazio = (X_cpreal(1)-Passeio2CG)/Lref;
PassioMEcheio = (X_cpreal(1)-Passeio3CG)/Lref;


figure
plot(Passeio2CG, PassioMEvazio,Passeio2CG,PassioMEcheio);
hold on
grid on
xlabel('X_{CG} cheio por lastro');
ylabel('ME');
title('Margem Estatica A0A = 0 ');

 
