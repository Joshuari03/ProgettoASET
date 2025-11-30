%% prima parte dove ricaviamo un vettore tempi di fermate

%%
clear
clc
close all
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