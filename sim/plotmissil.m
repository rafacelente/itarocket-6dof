fim_plot = 0;
while ~fim_plot
    imenu = menu('Plot 3D','Vel/Mach','Posi��o x tempo','Trajet�ria', ...
        'Angulos ataque/delta','Veloc Angular do corpo (p,q,r)', ...
        'Acel. do corpo','�ngulos Euler','For�as AED , CG(t)','For�as Propulsivas',...
        'Momentos Aerodin�micos','Momentos Propuls�o','Param. Vento','Fim');
    %close all
    switch imenu
        case 1 % Velocidade e Mach
            subplot(221);
            plot(Vb.Time,Vb.Data(:,1)); grid;
            xlabel ('t (s)');
            ylabel ('Vx (m/s)');
            
            subplot(222); 
            plot(Vb.Time,Vb.Data(:,2)); grid;
            xlabel ('t (s)');
            ylabel ('Vy');
            
            subplot(223); 
            plot(Vb.Time,Vb.Data(:,3)); grid;
            xlabel ('t (s)');
            ylabel ('Vz');
            
            subplot(224); 
            plot(Mach.Time,Mach.Data); grid;
            xlabel ('t (s)');
            ylabel ('Mach');
            
            saveas(gcf, 'LASC_Images/velocidades.png');
            
        case 2  % Posi��o x tempo
            subplot(221);
            plot(Xe.Time,Xe.Data(:,1)); grid;
            xlabel ('t (s)');
            ylabel ('Xe (m)');
            
            subplot(222);
            plot(Xe.Time,Xe.Data(:,2)); grid;
            xlabel ('t (s)');
            ylabel ('Ye (m)');
            
            subplot(223);
            plot(Xe.Time,-Xe.Data(:,3)); grid;
            xlabel ('t (s)');
            ylabel ('Ze Sea Level (m)');
            
            subplot(224);
            plot(Xe.Time,-Xe.Data(:,3)-D.Alt0); grid;
            xlabel ('t (s)');
            ylabel ('Ze Ground Level (m)');
            
            saveas(gcf, 'LASC_Images/posicao.png');
            
        case 3  % Trajet�ria
            subplot(221);
            plot(Xe.Data(:,1),-Xe.Data(:,3)); grid;
            xlabel ('Xe (m)');
            ylabel ('Ze (m)');
            axis('equal');
            
            subplot(222);
            plot(Xe.Data(:,1),Xe.Data(:,2)); grid;
            xlabel ('Xe (m)');
            ylabel ('Ye (m)');
            axis('equal');
            
            subplot(223);
            plot(Xe.Data(:,2),-Xe.Data(:,3)); grid;
            xlabel ('Ye (m)');
            ylabel ('Ze (m)');
            axis('equal');
            
            saveas(gcf, 'LASC_Images/trajetoria.png');
            
        case 4  % �ngulos de ataque e Delta
            subplot(221);
            plot(Alfa.Time,Alfa.Data/D2R); grid;
            xlabel ('t (s)');
            ylabel ('Alfa (graus)');
            
            subplot(222);
            plot(Beta.Time,Beta.Data/D2R); grid;
            xlabel ('t (s)');
            ylabel ('Beta (graus)');
            
            subplot(223);
            plot(Phi.Time,Phi.Data/D2R); grid;
            xlabel ('t (s)');
            ylabel ('Phi (graus)');
            
            
            saveas(gcf, 'LASC_Images/aoa.png');
         
        case 5  % p, q, r 
            subplot(221);
            plot(wb.Time,wb.Data(:,1)/D2R); grid;
            xlabel ('t (s)');
            ylabel ('p (graus/s)');
            
            subplot(222);
            plot(wb.Time,wb.Data(:,2)/D2R); grid;
            xlabel ('t (s)');
            ylabel ('q (graus/s)');
            
            subplot(223);
            plot(wb.Time,wb.Data(:,3)/D2R); grid;
            xlabel ('t (s)');
            ylabel ('r (graus/s)');
            
             subplot(224);
            plot(CGa.Time,CGa.Data(:,1)); grid;
            xlabel ('t (s)');
            ylabel ('CG ref :coifa');
                 
            saveas(gcf, 'LASC_Images/pqr.png');
            
        case 6  % Ax, Ay, Az
            subplot(221);
            plot(Ab.Time,Ab.Data(:,1)/g); grid;
            xlabel ('t (s)');
            ylabel ('A (g)'); %x (m/s2)
            
            subplot(222);
            plot(Ab.Time,Ab.Data(:,2)); grid;
            xlabel ('t (s)');
            ylabel ('Ay (m/s2)');
            
            subplot(223);
            plot(Ab.Time,Ab.Data(:,3)); grid;
            xlabel ('t (s)');
            ylabel ('Az (m/s2)');
            
            saveas(gcf, 'LASC_Images/aceleracao.png');
            
        case 7  % �ngulos de Euler
            subplot(221);
            plot(Euler.Time,Euler.Data(:,3)/D2R); grid;
            xlabel ('t (s)');
            ylabel ('psi (graus)');
            
            subplot(222);
            plot(Euler.Time,Euler.Data(:,2)/D2R); grid;
            xlabel ('t (s)');
            ylabel ('teta (graus)');
             
            subplot(223);
            plot(Euler.Time,Euler.Data(:,1)/D2R); grid;
            xlabel ('t (s)');
            ylabel ('phi (graus)');
            
            saveas(gcf, 'LASC_Images/angulos_euler.png');
            
        case 8  % For�as
            subplot(221);
            plot(FAer.Time,FAer.Data(:,1)); grid;
            xlabel ('t (s)');
            ylabel ('FAer_x (N)');
            
            subplot(222);
            plot(FAer.Time,FAer.Data(:,2)); grid;
            xlabel ('t (s)');
            ylabel ('FAer_y (N)');
            
            subplot(223);
            plot(FAer.Time,FAer.Data(:,3)); grid;
            xlabel ('t (s)');
            ylabel ('FAer_z (N)');
            
            
            subplot(224);
            plot(XCPefe.Time,-XCPefe.Data); grid;
            %plot(XCP.Time,(-XCP.Data+XCG.data(:,1))/D.L); grid;
            xlabel ('t (s)');
            ylabel ('Margem est�tica');
            

            
            saveas(gcf, 'LASC_Images/aerodinamica.png');
            
            case 9  % For�as
            subplot(221);
            plot(FProp.Time,FProp.Data(:,1)); grid;
            xlabel ('t (s)');
            ylabel ('FProp_x (N)');
            
            subplot(222);
            plot(FProp.Time,FProp.Data(:,2)); grid;
            xlabel ('t (s)');
            ylabel ('FProp_y (N)');
            
            subplot(223);
            plot(FProp.Time,FProp.Data(:,3)); grid;
            xlabel ('t (s)');
            ylabel ('FProp_z (N)');
            
            

            subplot(224);
            plot(FProp.Time,FProp.Data(:,1)); grid;
            xlabel ('t (s)');
            ylabel ('FProp (N)');
            
            
            saveas(gcf, 'LASC_Images/prop.png');
            
        case 10  % Momentos
            subplot(221);
            plot(MAer.Time,MAer.Data(:,1)); grid;
            xlabel ('t (s)');
            ylabel ('MAer_x (Nm)');
            
            subplot(222);
            plot(MAer.Time,MAer.Data(:,2)); grid;
            xlabel ('t (s)');
            ylabel ('MAer_y (Nm)');
            
            subplot(223);
            plot(MAer.Time,MAer.Data(:,3)); grid;
            xlabel ('t (s)');
            ylabel ('MAer_z (Nm)');
            
            
            saveas(gcf, 'LASC_Images/momento_aer.png');
            
        case 11  % Momentos
            subplot(221);
            plot(TorqProp.Time,TorqProp.Data(:,1)); grid;
            xlabel ('t (s)');
            ylabel ('TorqProp_x (Nm)');
            
            subplot(222);
            plot(TorqProp.Time,TorqProp.Data(:,2)); grid;
            xlabel ('t (s)');
            ylabel ('TorqProp_y (Nm)');
            
            subplot(223);
            plot(TorqProp.Time,TorqProp.Data(:,3)); grid;
            xlabel ('t (s)');
            ylabel ('TorqProp_z (Nm)');
            
            saveas(gcf, 'LASC_Images/momento_prop.png');
            
        case 12  % Parametros do vento
            subplot(231);
            plot(Vbwind.Time,Vbwind.Data(:,1)); grid;
            xlabel ('t (s)');
            ylabel ('Vb_wind_N');
            
            subplot(232);
            plot(Vbwind.Time,Vbwind.Data(:,2)); grid;
            xlabel ('t (s)');
            ylabel ('Vb_wind_E');
            
            subplot(233);
            plot(Vbwind.Time,Vbwind.Data(:,3)); grid;
            xlabel ('t (s)');
            ylabel ('Vb_wind_D');
            
            subplot(234);
            plot(wbwind.Time,wbwind.Data(:,1)); grid;
            xlabel ('t (s)');
            ylabel ('wb_wind_eixoN');
            
            subplot(235);
            plot(wbwind.Time,wbwind.Data(:,2)); grid;
            xlabel ('t (s)');
            ylabel ('wb_wind_eixoE');
            aerodinamica
            subplot(236);
            plot(wbwind.Time,wbwind.Data(:,3)); grid;
            xlabel ('t (s)');
            ylabel ('wb_wind_eixoD');
            
            
            saveas(gcf, 'LASC_Images/vento.png');
            

            
        case 13 % Fim
            fim_plot = 1;
    end
end