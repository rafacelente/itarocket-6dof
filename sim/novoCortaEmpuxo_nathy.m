function file_name = novoCortaEmpuxo_nathy(empuxo_velho, tempo_de_corte_inicial, tempo_de_corte_final, reduz_empuxo)
% Autor: Rafael Hipster(T23)
% Atualizações: Nathália Matos

% função para desconsiderar o período de empuxo durante o deslocamento da
% rampa visto que a simulação no Simulink é a partir da saída da rampa
% entradas:
% empuxo_velho: curva de empuxo original
% tempo_de_corte_inicial: instante de saída da rampa
% tempo_de_corte_final: tempo de queima
% reduz_empuxo: fator de redução do empuxo
% saída: 
% file_name: arquivo com nova curva de empuxo 

% Ultimos cortes:
% [R:0.65] [I: 0.444 + 0.52] -> [F: 6.6848] Empuxo.dat->Empuxo_RDX_6DOF.dat
% 0.444: tempo de queima na rampa
% 0.52: NAN ou valores não suficientes grandes, menores que o peso do
% foguete na rampa

% 1. Abrir o arquivo com a curva de empuxo original
tabela_de_empuxo = load(empuxo_velho);  % Trocar aqui o nome do arquivo de empuxo que quer cortar.

% 2. Localize os valores valores iniciais e finais de tempo que quer
% que o a nova tabela de empuxo tenha.
i = 1;
while (tabela_de_empuxo(i, 1) <= tempo_de_corte_inicial)
    i = i + 1;
end

j = i; %  tabela_de_empuxo(i-1, 1)<= tempo_de_corte_inicial < tabela_de_empuxo(i, 1)
while (tabela_de_empuxo(j, 1) <= tempo_de_corte_final)
    j = j + 1;
end
%  tabela_de_empuxo(j-1, 1)<= tempo_de_corte_final < tabela_de_empuxo(j, 1)

% 3. Coloque exatamente esses valores nas variaveis abaixo.
novo_empuxo = zeros(j-i+1, 2); % tabela_de_empuxo(i:j,:)
for (k = i:j)
    novo_empuxo(k-i+1,1) = tabela_de_empuxo(k,1) - tempo_de_corte_inicial;
    novo_empuxo(k-i+1,2) = tabela_de_empuxo(k,2)*reduz_empuxo;
end
% zerar empuxo após tempo de queima
novo_empuxo(j-i+2,1)=novo_empuxo(j-i+1,1)+0.01;
novo_empuxo(j-i+2,2)=0;

% 4. Troque os nomes dos arquivos de entrada e saída abaixo a gosto.
file_name = strcat(empuxo_velho(1:end-4),'_cortado.dat');
save(file_name, 'novo_empuxo', '-ascii');
end


