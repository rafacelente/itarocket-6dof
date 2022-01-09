function [CN,CM,CA,CY,CLN,CLL,CD,CNQ, CMQ, CAQ, CNAD, CMAD, CYR, CLNR, CLLR, CYP, CLNP ,CLLP] = DATCOMreader_nathy_reduzido(caso,FINSET1,FINSET2,dados)
%le arquivo do DATCOM e tira as informacoes uteis
% atualizado por Nathália Matos
% Data: 23/08/2021
% reduzido pois foram retiradas as informações de 
% CL,XCP,CNA,CMA,CYB,CLNB,CLLB,hinge


% abri arquivo 'for006'
out = fopen(caso);
Nmach = length(dados.mach);
Nalpha = length(dados.alpha);

% considera-se que o for006 foi gerado a partir da função gera_for005 onde
% considera as informações em 'dados'

for i=1:Nmach %Todos os valores serao feitos em funcao de cada Mach
    search_nathy('MACH NO',out);
    
    % ler as informações dos FINSETs
    a=8;
    b=10;
    if FINSET1.has==1
        search_nathy('ALPHA',out);     % reposiciona o indicador de posição do texto na 1ª posição da string 'ALPHA'
         linha=fgetl(out);        % retorna a linha a partir de 'ALPHA'
%         linha=fgetl(out);       % pula linha
%         for j=1:Nalpha
%             linha=fgetl(out);    % retorna a linha com os valores para cada ALPHA
%             numbers = search_number(linha,a,b); % os números da linha exceto ALPHA
%             for h=1:FINSET1.NPANEL
%                 hinge(1,h,j,i)=numbers(h);
%             end
%         end
    end
    if FINSET2.has==1
        search_nathy('ALPHA',out);    % reposiciona o indicador de posição do texto na 1ª posição da string 'ALPHA'
         linha=fgetl(out);       % retorna a linha a partir de 'ALPHA'
%         linha=fgetl(out);        % pula linha
%         for j=1:Nalpha
%             linha=fgetl(out);   % retorna a linha com os valores para cada ALPHA
%             numbers = search_number(linha,a,b); % os números da linha exceto ALPHA
%             for h=1:FINSET2.NPANEL
%                 hinge(2,h,j,i)=numbers(h);
%             end
%         end
    end
	a=14;
    b=10;
    % ler as informações dos coeficientes
    % CN,CM,CA,CY,CLN,CLL
    search_nathy('ALPHA',out);    % reposiciona o indicador de posição do texto na 1ª posição da string 'ALPHA'
    linha=fgetl(out);       % retorna a linha a partir de 'ALPHA'
    linha=fgetl(out);        % pula linha
    for j=1:Nalpha
        linha=fgetl(out);   % retorna a linha com os valores para cada ALPHA
        numbers = search_number(linha,a,b); % os números da linha exceto ALPHA
        CN(j,i)=numbers(1);
        CM(j,i)=numbers(2);
        CA(j,i)=numbers(3);
        CY(j,i)=numbers(4);
        CLN(j,i)=numbers(5);
        CLL(j,i)=numbers(6);
    end
  
    % ler as informações dos coeficientes
    % CL,CD,X-C.P.
    search_nathy('ALPHA',out);    % reposiciona o indicador de posição do texto na 1ª posição da string 'ALPHA'
    linha=fgetl(out);       % retorna a linha a partir de 'ALPHA'
    linha=fgetl(out);       % pula linha
    for j=1:Nalpha
        linha=fgetl(out);   % retorna a linha com os valores para cada ALPHA
        numbers = search_number(linha,a,b); % os números da linha exceto ALPHA
        %CL(j,i)=numbers(1);
        CD(j,i)=numbers(2);
        %XCP(j,i)=numbers(4);
    end
   
    a=14;
    b=12; 
    % ler as informações dos coeficientes
    % CNA,CMA,CYB,CLNB,CLLB : DERIVATIVES (PER RADIAN)
    search_nathy('ALPHA',out);    % reposiciona o indicador de posição do texto na 1ª posição da string 'ALPHA'
     linha=fgetl(out);       % retorna a linha a partir de 'ALPHA'
%     for j=1:Nalpha
%         linha=fgetl(out);   % retorna a linha com os valores para cada ALPHA
%         numbers = search_number(linha,a,b); % os números da linha exceto ALPHA
%         CNA(j,i)=numbers(1);
%         CMA(j,i)=numbers(2);
%         CYB(j,i)=numbers(3);
%         CLNB(j,i)=numbers(4);
%         CLLB(j,i)=numbers(5);
%     end
    
    a=14;
    b=11; 
    % ler as informações dos coeficientes
    % CNQ,CMQ,CAQ,CNAD,CMAD: DYNAMIC DERIVATIVES (PER RADIAN)
    search_nathy('ALPHA',out);    % reposiciona o indicador de posição do texto na 1ª posição da string 'ALPHA'
    linha=fgetl(out);       % retorna a linha a partir de 'ALPHA'
    for j=1:Nalpha
        linha=fgetl(out);
        numbers = search_number(linha,a,b); % os números da linha exceto ALPHA
        CNQ(j,i)=numbers(1);
        CMQ(j,i)=numbers(2);
        CAQ(j,i)=numbers(3);
        CNAD(j,i)=numbers(4);
        CMAD(j,i)=numbers(5);
    end
    
    % ler as informações dos coeficientes
    % CYR,CLNR,CLLR,CYP,CLNP,CLLP: DYNAMIC DERIVATIVES (PER RADIAN)
    search_nathy('ALPHA',out);    % reposiciona o indicador de posição do texto na 1ª posição da string 'ALPHA'
    linha=fgetl(out);       % retorna a linha a partir de 'ALPHA'
    for j=1:Nalpha
        linha=fgetl(out);
        numbers = search_number(linha,a,b); % os números da linha exceto ALPHA
        CYR(j,i)=numbers(1);
        CLNR(j,i)=numbers(2);
        CLLR(j,i)=numbers(3);
        CYP(j,i)=numbers(4);
        CLNP(j,i)=numbers(5);
        CLLP(j,i)=numbers(6);
    end
end
fclose(out);
end
