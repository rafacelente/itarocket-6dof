folder = 'Montenegro_2022_04_06';
fim_plot = 0;
D2R = pi/180;
g = 9.81;
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
            
            txt = strcat('Images/', folder, '/velocidades.png');
            saveas(gcf, txt);
            
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
            
            txt = strcat('Images/', folder, '/posicao.png');
            saveas(gcf, txt);
            
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
            
            txt = strcat('Images/', folder, '/trajetoria.png');
            saveas(gcf, txt);
            
        case 4  % �ngulos de ataque e Delta
            subplot(221);
            plot(Alfa.Time,Alfa.Data/D2R); grid;
            xlabel ('t (s)');
            ylabel ('$\alpha$ (degrees)', 'Interpreter','latex');
            
            subplot(222);
            plot(Beta.Time,Beta.Data/D2R); grid;
            xlabel ('t (s)');
            ylabel ('$\beta$ (degrees)', 'Interpreter','latex');
            
            subplot(223);
            plot(Phi.Time,Phi.Data/D2R); grid;
            xlabel ('t (s)');
            ylabel ('$\phi$ (degrees)', 'Interpreter','latex');
            
            
            txt = strcat('Images/', folder, '/aoa.png');
            saveas(gcf, txt);
         
        case 5  % p, q, r
            subplot(221);
            plot(wb.Time,wb.Data(:,1)/D2R); grid;
            xlabel ('t (s)');
            ylabel ('p (degrees/s)');
            
            subplot(222);
            plot(wb.Time,wb.Data(:,2)/D2R); grid;
            xlabel ('t (s)');
            ylabel ('q (degrees/s)');
            
            subplot(223);
            plot(wb.Time,wb.Data(:,3)/D2R); grid;
            xlabel ('t (s)');
            ylabel ('r (degrees/s)');
            
             subplot(224);
            plot(XCG.Time,XCG.Data(:,1)); grid;
            xlabel ('t (s)');
            ylabel ('CG ref: nose');
                 
            txt = strcat('Images/', folder, '/pqr.png');
            saveas(gcf, txt);
            
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
            
            txt = strcat('Images/', folder, '/aceleracao.png');
            saveas(gcf, txt);
            
        case 7  % �ngulos de Euler
            subplot(221);
            plot(Euler.Time,Euler.Data(:,3)/D2R); grid;
            xlabel ('t (s)');
            ylabel ('$\psi$ (degrees)', 'Interpreter','latex');
            
            subplot(222);
            plot(Euler.Time,Euler.Data(:,2)/D2R); grid;
            xlabel ('t (s)');
            ylabel ('$\theta$ (degrees)', 'Interpreter','latex');
             
            subplot(223);
            plot(Euler.Time,Euler.Data(:,1)/D2R); grid;
            xlabel ('t (s)');
            ylabel ('$\phi$ (degrees)', 'Interpreter','latex');
            
            txt = strcat('Images/', folder, '/angulos_euler.png');
            saveas(gcf, txt);
            
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
            plot(XCP.Time,-XCP.Data); grid;
            %plot(XCP.Time,(-XCP.Data+XCG.data(:,1))/D.L); grid;
            xlabel ('t (s)');
            ylabel ('Margem est�tica');
            

            
            txt = strcat('Images/', folder, '/aerodinamica.png');
            saveas(gcf, txt);
            
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
            
            
            txt = strcat('Images/', folder, '/prop.png');
            saveas(gcf, txt);
            
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
            
            
            txt = strcat('Images/', folder, '/momentos_aer.png');
            saveas(gcf, txt);
            
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
            
            txt = strcat('Images/', folder, '/momentos_prop.png');
            saveas(gcf, txt);
            
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
            
            
            txt = strcat('Images/', folder, '/vento.png');
            saveas(gcf, txt);
            

            
        case 13 % Fim
            fim_plot = 1;
    end
end