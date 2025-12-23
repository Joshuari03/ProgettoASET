% folderPath = '/home/joshuarizzello/Documents/Repos/ProgettoASET';
% addpath(genpath(folderPath))
%% prima parte dove ricaviamo un vettore tempi di fermate
clearvars
close all
clc
run("DataElaboration.m")
tot_ST_and = sum(Mean_ST_and);
tot_ST_rit = sum(Mean_ST_rit);
d   = 0.17;          % 170 mm air‑gap (nominal)
Ptx = 200e3;         % 100 kW
mis = 0.05;
E_battery = 300;     % 300 kWh di capacità

Prx = polyphase_wpt_model(d,Ptx,mis) / 1e3;

fprintf('Delivered power (5 percent mis) = %.1f kW\n',Prx);

%Recharged_energy_and = Prx * tot_ST_and / 3600;

WPT_stops_and = false(1, length(Mean_ST_rit));
WPT_stops_and([1 12]) = true; %indici delle fermate in cui si intende mettere le piattaforme di ricarica 
Mean_ST_and(WPT_stops_and) = [180 180]; %ipotizzando di fermarsi 3 min a Piazza 5 giornate e 3 min a Linate

WPT_stops_rit = false(1, length(Mean_ST_rit));
WPT_stops_rit([1 14]) = true; %indici delle fermate in cui si intende mettere le piattaforme di ricarica 
Mean_ST_rit(WPT_stops_rit) = [300 180]; %Ipotizzando di fermarsi 5 min a San Felicino e 3 min a Linate

Recharged_energy_and = Prx * sum(Mean_ST_and(WPT_stops_and))/ 3600;
Recharged_energy_and_percent = Recharged_energy_and / E_battery * 100;
fprintf('Recharged energy (outbund) (nominal) = %.1f kWh, Percentage = %.1f %%\n', Recharged_energy_and, Recharged_energy_and_percent);
% Recharged_energy_rit = Prx * tot_ST_rit / 3600;
Recharged_energy_rit = Prx * sum(Mean_ST_rit(WPT_stops_rit)) / 3600;
Recharged_energy_rit_percent = Recharged_energy_rit / E_battery * 100;
fprintf('Recharged energy (return) (nominal) = %.1f kWh, Percentage = %.1f %%\n', Recharged_energy_rit, Recharged_energy_rit_percent);

E_mean_and = mean(E_tot_a);
E_mean_and_percent = E_mean_and / E_battery * 100;
fprintf('Avg consumption (outbund) = %.1f kWh, Percentage = %.1f %%\n',E_mean_and, E_mean_and_percent);
E_mean_rit = mean(E_tot_r);
E_mean_rit_percent = E_mean_rit / E_battery * 100;
fprintf('Avg consumption (return) = %.1f kWh, Percentage = %.1f %%\n',E_mean_rit, E_mean_rit_percent);

fprintf('Recharged energy (outbund) (nominal) in percentage with respect to the avg consumption = %.1f %%\n',Recharged_energy_and / E_mean_and *100);
fprintf('Recharged energy (return) (nominal) in percentage with respect to the avg consumption = %.1f %%\n',Recharged_energy_rit / E_mean_rit *100);
fprintf('Total recharged energy in percentage with respect to the avg consumption = %.1f %%\n', (Recharged_energy_and +Recharged_energy_rit)/ (E_mean_and + E_mean_rit) *100);

Recharged_E_per_stop_and = Prx * (Mean_ST_and.*WPT_stops_and) / 3600; %a 0 le fermate in cui non si ricarica
Recharged_E_per_stop_rit = Prx * (Mean_ST_rit.*WPT_stops_rit) / 3600; %a 0 le fermate in cui non si ricarica

Recharged_E_per_stop_and_percentage = Recharged_E_per_stop_and / E_mean_and * 100;
Recharged_E_per_stop_rit_percentage = Recharged_E_per_stop_rit / E_mean_rit * 100;

% fprintf('Recharged energy (outbund) (nominal) in percentage without end of the line stop = %.1f %%\n',sum(Recharged_E_per_stop_and_percentage(2:end)));
% fprintf('Recharged energy (return) (nominal) in percentage without end of the line stop = %.1f %%\n',sum(Recharged_E_per_stop_rit_percentage(2:end)));

figure
bar(Recharged_E_per_stop_and_percentage);
title('Energia ricaricata per fermata in relazione al consumo medio per tutta la tratta di andata')
xlabel('Fermate');
ylabel('Energia ricaricata (%)');
figure
bar(Recharged_E_per_stop_rit_percentage);title('Energia ricaricata per fermata in relazione al consumo medio per tutta la tratta di ritorno')
xlabel('Fermate');
ylabel('Energia ricaricata (%)');

figure
bar(Mean_ST_and(1:end))
title("tempi di feramata andata")
xlabel("fermate")
ylabel("secondi fermata")
figure
bar(Mean_ST_rit(1:end))
title("tempi di feramata ritorno")
xlabel("fermate")
ylabel("secondi fermata")


p_tot = cellfun(@(x, y) [x; y], p_tot_a, p_tot_r, "UniformOutput",false);

figure
for i = 1:length(D_and)
  % plot SoC
    % Parametri della batteria
    battery_capacity = 300; % Capacità della batteria in kWh
    initial_charge = battery_capacity; % Carica iniziale della batteria
    
    % Calcolo dello stato di carica nel tempo
    ttt_and = seconds(D_and(i).Acceleration.Timestamp - D_and(i).Acceleration.Timestamp(1));
    ttt_rit = seconds(D_rit(i).Acceleration.Timestamp - D_rit(i).Acceleration.Timestamp(1)); % Calcolo del tempo per il ritorno
    ttt = [ttt_and ; max(ttt_and)+ttt_rit];
    soc = initial_charge - cumtrapz(ttt, p_tot{i})/3.6e6;
    plot(ttt ,soc/battery_capacity*100)
    
    hold on
end
title("Andamento SoC complessivo di A/R")
yticks(0:1:100); % Imposta i tick dell'asse y per visualizzare la percentuale di SoC ogni 1%
xlabel("Tempo tragitto A/R (s)")
ylabel('Stato di carica (SoC) (%)'); % Etichetta dell'asse y
ax = gca; % Ottieni l'asse corrente
ax.YAxis.TickLabelFormat = '%d%%'; % Imposta il formato dei tick dell'asse y per includere il simbolo %
grid on
grid minor
hold off
%%
%% Condizioni nominali
d   = 0.17;          % 170 mm air‑gap (nominal)
Ptx = 300e3;          % 100 kW
mis = 0;              % perfect alignment

Prx = polyphase_wpt_model(d,Ptx,mis);
fprintf('Delivered power (nominal) = %.1f kW\n',Prx/1e3);
%% Plot Power vs. Distance (0% Mis-alignment) 

% Example 3 – plot efficiency vs distance (0‑30 cm) for 0 % mis‑alignment
d_vals = 0:0.005:0.30;
Ptx = 300e3;
mis = 0; 

Prx_vals = arrayfun(@(d)polyphase_wpt_model(d,Ptx,0),d_vals);

figure;
plot(d_vals,Prx_vals/1e3,'LineWidth',2);
grid on
xlabel('Distance d (m)'); ylabel('Delivered Power (kW)');
title('Delivered Power vs Distance (0% misalignment)');

%% Plot Power vs. Mis‑alignment (distance fixed to nominal)
d_fixed = 0.17;
mis_vals = linspace(0,1,201);                % 0 % → 100 % mis‑alignment
P_rx_mis = arrayfun(@(mis) polyphase_wpt_model(d_fixed,Ptx,mis),mis_vals);

figure('Name','Delivered Power vs. Mis‑alignment','NumberTitle','off');
plot(mis_vals, P_rx_mis/1e3,'LineWidth',2,'Color',[0 0.4470 0.7410]);
grid on; box on
xlabel('Mis‑alignment (fraction of worst case)');   % 0 = perfect, 1 = no coupling
ylabel('Delivered Power (kW)');
title(sprintf('Delivered Power @ d = %.3f m (fixed distance)',d_fixed));
xlim([0 1]); ylim([0 max(P_rx_mis)/1e3*1.05])

%% 3D plot (Distance × Mis‑alignment)

d_vals  = 0:0.01:0.30;            % Distance vector – 15 cm to 30 cm
mis_vals2 = 0:0.02:1;                % 0 % → 100 % mis‑alignment

% Mesh grid di (distance, mis‑alignment)
[DM,MM] = meshgrid(d_vals,mis_vals2);


PRx_grid = arrayfun(@(d,mis) polyphase_wpt_model(d,Ptx,mis), DM, MM);


figure('Name','Delivered Power vs. Distance & Mis‑alignment','NumberTitle','off');
surf(DM,MM,PRx_grid/1e3);
shading interp;            
colorbar; 

hold on

% griglia sopra la superficie
m = mesh(DM, MM, PRx_grid/1e3);
m.FaceColor = 'none'; 
m.EdgeColor = [0 0 0];  % griglia nera, sottile
m.LineWidth = 0.3;

hold off

xlabel('Distance d (m)');
ylabel('Mis‑alignment (fraction)');
zlabel('Delivered Power (kW)');
title('Delivered Power as a function of Distance and Mis‑alignment');              

