function gera_for005(for005)
% função que gera o for005 inicial para a função de obtenção dos coeficientes
% aerodinâmicos (gera_coef) de acordo com dados do corpo do foguete e das
% FINSET2 caso tiver
% consulte Read me for gera_for005.txt


% criar  for005.dat
fileID = fopen('for005.dat','w');
% 'w'     open file for writing; discard existing contents

%%% initial Control Card
fprintf(fileID,'DIM %s\r\n',for005.CARD.DIM);                   % comprimentos nos resultados em metros
fprintf(fileID,'DERIV %s\r\n',for005.CARD.DERIV);               % ângulos nos resultados em radianos
if for005.CARD.hasDAMP==1
    fprintf(fileID,'DAMP\r\n');
end
%%% Refrence Quantities

fprintf(fileID,'$REFQ     XCG=%.4f,',for005.REFQ.XCG);     % posição do CG do míssil

if for005.REFQ.hasSREF ==1
    fprintf(fileID,'\r\n');
    fprintf(fileID,'          SREF=%.8f,',for005.REFQ.SREF);% área de referência
    
end
if for005.REFQ.hasLREF ==1
    fprintf(fileID,'\r\n');
    fprintf(fileID,'          LREF=%.4f,',for005.REFQ.LREF);% comprimento de referência
    
end
if for005.REFQ.hasBLAYER ==1
    fprintf(fileID,'\r\n');
    fprintf(fileID,'          BLAYER=%s,',for005.REFQ.BLAYER);  % considera a camada limite turbulenta
    
end
if for005.REFQ.hasSCALE ==1
    fprintf(fileID,'\r\n');
    fprintf(fileID,'          SCALE=%.2f,',for005.REFQ.SCALE);  % considera a camada limite turbulenta
    
end
fprintf(fileID,'%s\r\n','$');



%%% Axisymmetric Body Geometry

if for005.AXIBOD.option ==1
    fprintf(fileID,'$AXIBOD   TNOSE=%s, \r\n',for005.AXIBOD.TNOSE);
    fprintf(fileID,'          LNOSE=%.4f, \r\n',for005.AXIBOD.LNOSE);
    fprintf(fileID,'          DNOSE=%.4f, \r\n',for005.AXIBOD.DNOSE);
    fprintf(fileID,'          BNOSE=%.4f, \r\n',for005.AXIBOD.BNOSE);
    fprintf(fileID,'          LCENTR=%.4f, \r\n',for005.AXIBOD.LCENTR);
    fprintf(fileID,'          DEXIT=%.0f.,$\r\n',for005.AXIBOD.DEXIT);
else
    fprintf(fileID,'$AXIBOD   NX=%.0f., \r\n',for005.AXIBOD.NX);   % números de pontos
    fprintf(fileID,'          X=%.7f, \r\n',for005.AXIBOD.X(1));
    fprintf(fileID,'            %.7f, \r\n',for005.AXIBOD.X(2:end));
    fprintf(fileID,'          R=%.6f, \r\n',for005.AXIBOD.R(1));
    fprintf(fileID,'            %.6f, \r\n',for005.AXIBOD.R(2:end));
    fprintf(fileID,'          DISCON=');
    fprintf(fileID,'%.0f.,',for005.AXIBOD.DISCON);
    fprintf(fileID,'\r\n');
    fprintf(fileID,'          DEXIT=%.0f.,$\r\n',for005.AXIBOD.DEXIT); % considera o arrasto de forma nos cálculos
end
%%% Define Fin Set 1
if for005.FINSET1.has==1
    fprintf(fileID,'$FINSET1  SSPAN=');
    fprintf(fileID,'%.4f,',for005.FINSET1.SSPAN);
    fprintf(fileID,'\r\n');
    fprintf(fileID,'          CHORD=');
    fprintf(fileID,'%.4f,',for005.FINSET1.CHORD);
    fprintf(fileID,'\r\n');
    if for005.FINSET1.hasCFOC == 1
        fprintf(fileID,'          CFOC=');
        fprintf(fileID,'%.0f.,',for005.FINSET1.CFOC);
        fprintf(fileID,'\r\n');
    end
    fprintf(fileID,'          XLE=');
    fprintf(fileID,'%.3f,',for005.FINSET1.XLE);
    fprintf(fileID,'\r\n');
    if for005.FINSET1.hasZUPPER == 1
        fprintf(fileID,'          ZUPPER=');
        fprintf(fileID,'%.5f,',for005.FINSET1.ZUPPER);
        fprintf(fileID,'\r\n');
    end
    if for005.FINSET1.hasLMAXU == 1
        fprintf(fileID,'          LMAXU=');
        fprintf(fileID,'%.5f,',for005.FINSET1.LMAXU);
        fprintf(fileID,'\r\n');
    end
    if for005.FINSET1.hasLFLATU == 1
        fprintf(fileID,'          LFLATU=');
        fprintf(fileID,'%.5f,',for005.FINSET1.LFLATU);
        fprintf(fileID,'\r\n');
    end
    if for005.FINSET1.hasLER == 1
        fprintf(fileID,'          LER=');
        fprintf(fileID,'%.5f,',for005.FINSET1.LER);
        fprintf(fileID,'\r\n');
    end
    fprintf(fileID,'          NPANEL=%.0f.,',for005.FINSET1.NPANEL);
    if for005.FINSET1.hasPHIF==1
        fprintf(fileID,'\r\n');
        fprintf(fileID,'          PHIF=');
        fprintf(fileID,'%.0f.,',for005.FINSET1.AngleSET);
    end
    fprintf(fileID,'%s\r\n','$');
end
%
%%% Define Fin Set 2
if for005.FINSET2.has==1
    fprintf(fileID,'$FINSET2  SSPAN=');
    fprintf(fileID,'%.4f,',for005.FINSET2.SSPAN);
    fprintf(fileID,'\r\n');
    fprintf(fileID,'          CHORD=');
    fprintf(fileID,'%.4f,',for005.FINSET2.CHORD);
    fprintf(fileID,'\r\n');
    if for005.FINSET2.hasCFOC == 1
        fprintf(fileID,'          CFOC=');
        fprintf(fileID,'%.0f.,',for005.FINSET2.CFOC);
        fprintf(fileID,'\r\n');
    end
    fprintf(fileID,'          XLE=');
    fprintf(fileID,'%.3f,',for005.FINSET2.XLE);
    fprintf(fileID,'\r\n');
    if for005.FINSET2.hasZUPPER == 1
        fprintf(fileID,'          ZUPPER=');
        fprintf(fileID,'%.5f,',for005.FINSET2.ZUPPER);
        fprintf(fileID,'\r\n');
    end
    if for005.FINSET2.hasLMAXU == 1
        fprintf(fileID,'          LMAXU=');
        fprintf(fileID,'%.5f,',for005.FINSET2.LMAXU);
        fprintf(fileID,'\r\n');
    end
    if for005.FINSET2.hasLFLATU == 1
        fprintf(fileID,'          LFLATU=');
        fprintf(fileID,'%.5f,',for005.FINSET2.LFLATU);
        fprintf(fileID,'\r\n');
    end
    if for005.FINSET2.hasLER == 1
        fprintf(fileID,'          LER=');
        fprintf(fileID,'%.5f,',for005.FINSET2.LER);
        fprintf(fileID,'\r\n');
    end
    fprintf(fileID,'          NPANEL=%.0f.,',for005.FINSET2.NPANEL);
    if for005.FINSET2.hasPHIF==1
        fprintf(fileID,'\r\n');
        fprintf(fileID,'          PHIF=');
        fprintf(fileID,'%.0f.,',for005.FINSET2.AngleSET);
    end
    fprintf(fileID,'%s\r\n','$');
end

%%% define Panel incidence (deflection) values
if for005.DEFLCT.hasDELTA1 ==1
    fprintf(fileID,'$DEFLCT   DELTA1=');
    fprintf(fileID,'%.0f,',for005.DEFLCT.DELTA1);
    if for005.DEFLCT.hasDELTA2 ==1
        fprintf(fileID,'\r\n');
        fprintf(fileID,'           DELTA2 =');
        fprintf(fileID,'%.1f,',for005.DEFLCT.DELTA2);
    end
else
    if for005.DEFLCT.hasDELTA2 ==1
        fprintf(fileID,'$DEFLCT        DELTA2 =');
        fprintf(fileID,'%.1f,',for005.DEFLCT.DELTA2);
    end
end
if for005.DEFLCT.hasXHINGE ==1
    fprintf(fileID,'\r\n');
    fprintf(fileID,'          XHINGE=');
    fprintf(fileID,'%.3f,',for005.DEFLCT.XHINGE);
end
fprintf(fileID,'$\r\n');

%%% Flight Conditions (Angles of attack, Altitudes, etc.)

fprintf(fileID,'$FLTCON   NALPHA=%.1f,\r\n',for005.FLTCON.NALPHA);
fprintf(fileID,'          ALPHA=%.1f,\r\n',for005.FLTCON.ALPHA(1));
fprintf(fileID,'          %.1f,\r\n',for005.FLTCON.ALPHA(2:end));
if for005.FLTCON.hasBETA==1
    fprintf(fileID,'          BETA=%.2f,\r\n',for005.FLTCON.BETA);
end
fprintf(fileID,'          NMACH=%.1f,\r\n',for005.FLTCON.NMACH);
fprintf(fileID,'          MACH=%.2f,\r\n',for005.FLTCON.MACH(1));
fprintf(fileID,'          %.2f,\r\n',for005.FLTCON.MACH(2:end));

fprintf(fileID,'          ALT=%.1f,\r\n',for005.FLTCON.ALT(1));
fprintf(fileID,'          %.1f,\r\n',for005.FLTCON.ALT(2:end-1));
fprintf(fileID,'          %.1f,$\r\n',for005.FLTCON.ALT(end));

%%% Final Control Card
if for005.CARD.hasPRINTAEROHINGE ==1
    fprintf(fileID,'PRINT AERO HINGE\r\n');
end
if for005.CARD.hasSAVE ==1
    fprintf(fileID,'SAVE\r\n');
end
if for005.CARD.hasNEXTCASE ==1
    fprintf(fileID,'NEXT CASE\r\n');
end
fclose(fileID);
end

