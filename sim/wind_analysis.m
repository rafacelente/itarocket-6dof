function wind_analysis(apogees, max_wind_speed)
    wind_speeds = 0:0.5:max_wind_speed;
    a = plot(wind_speeds, apogees, 'LineWidth', 1); grid;
    hold on
    b = plot([0 max_wind_speed], [3048 3048], 'r--', 'LineWidth', 2);
    text(4, 3060, '10k ft Threshold')
    xlabel ('Wind speed (m/s)');
    ylabel ('Apogee (m)');
    
    pp = polyfit(wind_speeds, apogees, 2);
    
    xx = linspace(0, max_wind_speed, 100);
    yy = polyval(pp, xx);
    hold on
    

    
    
    txt = strcat('$Apogee(x)$ = ' , num2str(pp(1)) , '$x^2 $' , num2str(pp(2)) , '$x + $ ' , num2str(pp(3)));
    text(3, 2950, txt, 'Interpreter','latex');
    title('Wind speed influence on the rockets apogee', 'Interpreter','latex');
    
    time = datestr(clock,'YYYY_mm_dd');
    save_text = strcat('Images/wind_influence_', time, '.png');
    saveas(gcf, save_text);
end
