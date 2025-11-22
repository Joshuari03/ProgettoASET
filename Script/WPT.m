%% prima parte dove ricaviamo un vettore tempi di fermate

%% sfsafs
% out = polyphase_wpt_model(17,10, 570);

%%
clear all
clc
close all
%% 

% Example 1 – nominal operation
d   = 0.17;          % 170 mm air‑gap (nominal)
Ptx = 300e3;          % 100 kW
mis = 0;              % perfect alignment
Prx = polyphase_wpt_model(d,Ptx,mis);
fprintf('Delivered power (nominal) = %.1f kW\n',Prx/1e3);
%  → Delivered power (nominal) = 95.7 kW
%% 

% Example 2 – increased distance & 5 % mis‑alignment
d   = 0.20;          % 200 mm air‑gap
mis = 0.05;          % 5 % loss
Prx = polyphase_wpt_model(d,Ptx,mis);
fprintf('Delivered power (20 cm, 5%% mis) = %.1f kW\n',Prx/1e3);
%  → Delivered power (20 cm, 5% mis) = 70.3 kW
%% 

% Example 3 – plot efficiency vs distance (0‑30 cm) for 0 % mis‑alignment
d_vals = 0:0.005:0.30;           % 15 cm to 30 cm
Prx_vals = arrayfun(@(d)polyphase_wpt_model(d,Ptx,0),d_vals);
figure; plot(d_vals,Prx_vals/1e3,'LineWidth',2); grid on
xlabel('Distance d (m)'); ylabel('Delivered Power (kW)')
title('Delivered Power vs Distance (0% misalignment)');


%% --- 2. Plot: Power vs. Mis‑alignment (distance fixed) ---------------
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

%% --- 3. Plot: 3‑D Surface (Distance × Mis‑alignment) ----------------
% Distance vector – 15 cm to 30 cm (the range that was used for the
% 1‑D distance sweep in the original example)
d_vals  = 0:0.01:0.30;            % m
mis_vals2 = 0:0.02:1;                % 0 % → 100 % mis‑alignment

% Create a mesh grid of (distance, mis‑alignment) pairs
[DM,MM] = meshgrid(d_vals,mis_vals2);

% Evaluate the model over the grid (2‑D array of delivered power)
%  NOTE: arrayfun works element‑wise for the two inputs.
PRx_grid = arrayfun(@(d,mis) polyphase_wpt_model(d,Ptx,mis), DM, MM);

% 3‑D surface – use kW for the Z axis so the axes are all in familiar units
figure('Name','Delivered Power vs. Distance & Mis‑alignment','NumberTitle','off');
surf(DM,MM,PRx_grid/1e3);
shading interp;            % colour map of your choice
colorbar; 
hold on

% --- griglia disegnata sopra la superficie ---
m = mesh(DM, MM, PRx_grid/1e3);
m.FaceColor = 'none'; 
m.EdgeColor = [0 0 0];  % griglia nera, sottile
m.LineWidth = 0.3;

hold off% show colour scale

xlabel('Distance d (m)');
ylabel('Mis‑alignment (fraction)');
zlabel('Delivered Power (kW)');
title('Delivered Power as a function of Distance and Mis‑alignment');
view(30,30);              % set a nice viewing angle
axis tight;               % tighten axes around the data
clim([0 max(PRx_grid(:))/1e3]);   % scale colour bar to data range
