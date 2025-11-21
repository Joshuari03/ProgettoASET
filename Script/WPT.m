%% prima parte dove ricaviamo un vettore tempi di fermate

%% sfsafs
out = polyphase_wpt_model(17,10, 570);

%%
clear all
clc
close all
% Example 1 – nominal operation
d   = 0.17;          % 170 mm air‑gap (nominal)
Ptx = 300e3;          % 100 kW
mis = 0;              % perfect alignment
Prx = polyphase_wpt_model(d,Ptx,mis);
fprintf('Delivered power (nominal) = %.1f kW\n',Prx/1e3);
%  → Delivered power (nominal) = 95.7 kW

% Example 2 – increased distance & 5 % mis‑alignment
d   = 0.20;          % 200 mm air‑gap
mis = 0.05;          % 5 % loss
Prx = polyphase_wpt_model(d,Ptx,mis);
fprintf('Delivered power (20 cm, 5%% mis) = %.1f kW\n',Prx/1e3);
%  → Delivered power (20 cm, 5% mis) = 70.3 kW

% Example 3 – plot efficiency vs distance (0‑30 cm) for 0 % mis‑alignment
d_vals = 0.15:0.01:0.30;           % 15 cm to 30 cm
Prx_vals = arrayfun(@(d)polyphase_wpt_model(d,Ptx,0),d_vals);
figure; plot(d_vals,Prx_vals/1e3,'LineWidth',2); grid on
xlabel('Distance d (m)'); ylabel('Delivered Power (kW)')
title('Delivered Power vs Distance (0% misalignment)');

% Example 3 – plot efficiency vs distance (0‑30 cm) for 15 % mis‑alignment
d_vals = 0.15:0.01:0.30;           % 15 cm to 30 cm
Prx_vals = arrayfun(@(d)polyphase_wpt_model(d,Ptx,0.15),d_vals);
figure; plot(d_vals,Prx_vals/1e3,'LineWidth',2); grid on
xlabel('Distance d (m)'); ylabel('Delivered Power (kW)')
title('Delivered Power vs Distance (0% misalignment)');
