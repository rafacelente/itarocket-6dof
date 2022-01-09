function tabela = gera_tabela_CDXMach_nathy(Mach,M_CD)
% gera a tabela CDxMach 
%load('AED_RDX.mat');
% Autor: Rafael (T23)
%machs = [0.0600 0.0900 0.1000 0.2000 0.3000 0.3500 0.4000 0.6000 0.7000 0.8000 0.9500 1.1000];
total_size = length(Mach);
tabela_cd = zeros(total_size,2);

for (i = 1:total_size)
    tabela_cd(i,1) = Mach(i);
    % tabela_cd(i,2) = M_CD(1,1,1,1,1,i,7,3);
    % Temos um problema aqui, o M_CD do 'AED_RDX.mat' é 4D
    tabela_cd(i,2) = M_CD(1,1,1,1,1,i,7,3);
end

save ENTRADAS/Tabela_CDxMach.dat tabela_cd -ascii
tabela = 'ENTRADAS/Tabela_CDxMach.dat';
end