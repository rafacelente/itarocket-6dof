function search(texto,file)
% função que localiza a string texto no arquivo file
% e reposiciona a posição do indicador do arquivo
% a posição é indicada em bytes em relação ao começo do arquivo
% saída: aqui (struct com linha e coluna)


% parâmetros auxiliares
flag=0;  % encontrar a string
% aqui: localiza a atual posição do indicador do arquivo para iniciar análise
% a: para percorrer a linha a fim de encontrar o texto
% c: para percorrer a linha a fim de encontrar o caracter '=' após o texto
% encontrado

while flag==0    
    % ftell: retorna a posição do atual indicador do arquivo. 
    aqui=ftell(file);  
    % fgetl: retorna a próxima linha do arquivo em relação a linha do atual indicador
    linha=fgetl(file); 
    for a=1:(length(linha)-length(texto)+1)  % percurrendo a linha
        if strcmp(linha(a:a-1+length(texto)),texto) % se encontra o texto na linha
            flag=1;
            % fseek(file,b+a,-1): reposiciona o indicador de posição de byte no arquivo
            % com OFFSET em relação ao início do arquivo
            aqui = aqui+a; % posição do primeiro caracter do texto
            fseek(file,aqui-1,-1);             
        end
    end
end
 
end