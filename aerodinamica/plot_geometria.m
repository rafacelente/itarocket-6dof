function plot_geometria(for005,InputEmpenas,OutEmpenas)
%--------------------------------------------------------------------------
%--- VISUALIZAR O DESENHO COM EMPENAS.---------
%--------------------------------------------------------------------------
if for005.FINSET1.has == 1

xe1 = linspace(0,OutEmpenas.x1,7)+for005.FINSET1.XLE(1);
ye1 = tand(OutEmpenas.AlphaAT)*(xe1-for005.FINSET1.XLE(1))+InputEmpenas.R;

pemp = ye1(end); % ponta da empena

% desenho reto da secao na ponta.
xe2 = linspace(0,OutEmpenas.Ctip,6)+xe1(end);
ye2 = linspace(pemp,pemp,6);


if(OutEmpenas.BetaSaida==90)
    xe3 = linspace(xe2(end),xe2(end),6);
    ye3a = linspace(InputEmpenas.R,pemp,6);
    ye3 = ye3a(length(ye3a):-1:1);
elseif (OutEmpenas.BetaSaida<90)
    xe3 = linspace(0,InputEmpenas.SPAN/(tand(InputEmpenas.BetaSaida)),6)+empenas.XLE(1)+OutEmpenas.CordaRaiz;
    ye3 = (xe3-empenas.XLE(1)-OutEmpenas.CordaRaiz)*tand(InputEmpenas.BetaSaida)+InputEmpenas.R;
else
    xe3 = linspace(0,-InputEmpenas.SPAN/(tand(InputEmpenas.BetaSaida)),6)+empenas.XLE(2)+OutEmpenas.Ctip;
    ye3 = (xe3-empenas.XLE(2)-OutEmpenas.Ctip)*tand(InputEmpenas.BetaSaida)+InputEmpenas.R+InputEmpenas.SPAN;
end
    


XEMP = [xe1 xe2 xe3];
YEMP = [ye1 ye2 ye3];
end

if for005.AXIBOD.option == 2
h = figure(1); % Creating a figure
plot(for005.AXIBOD.X,for005.AXIBOD.R,'-k', 'LineWidth', 3);
hold on;
plot(for005.AXIBOD.X,-for005.AXIBOD.R,'-k', 'LineWidth', 3);
grid on;
title('Geometria-ROCKET Com Empenas');
plot(XEMP,YEMP,'-r');
if(for005.FINSET1.NPANEL==4)
    plot(XEMP,-YEMP,'-r');
end
legend('pontos_{DATCOM}');

axis equal;
axis([0 3 -0.5 0.5]);
end
end