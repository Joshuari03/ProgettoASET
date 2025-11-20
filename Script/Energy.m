function [E] = Energy (acc_cleaned, velocity, time_gps, time_acc)
%time_gps = Position.Timestamp; --> dati presi dal gps
%time_acc = Acceleration.Timestamp; --> dati presi dall'accelerometro


a = acc_cleaned;
% a_pos = a; 
% a_pos(a_pos < 0) = 0; %tolgo gli elementi negativi dell'acc per trovare la potenza senza rigenerazione
m = 20e3;
v = velocity;

t_s = seconds(time_acc - time_acc(1));
g = 9.80665; % accelerazione di gravità
Crr = 0.008; % coefficiente di attrito ruota strada
rho = 1.225; % coefficiente attrito dell'aria
CdA = 8; % area frontale bus per attrito aero
eta = 0.8; % efficienza trasmissione tra batteria e ruote

v_interp = interp1(time_gps, v, time_acc, 'linear', 'extrap');
% figure
% plot(time_gps, v);
% figure
% plot(time_acc, v_interp*3.6);
% grid on
% grid minor
% title('velocità interpolata km/h')

%% Potenza servizi ausiliari
p_aux = 5000;

%% calcolo potenza istantanea
p_acc = m *a .*v_interp;

% figure
% plot(time_acc , p_acc);
% grid on
% grid minor
% title('potenza istantanea (solo m*a*v)')

%% calcolo potenza attrito ruota gomma
p_roll = m * g * Crr .* v_interp;

%% calcolo potenza attrito aerodinamico
p_aero   = 0.5 * rho * CdA .* v_interp.^3;

%% calcolo energia senza considerare la frenata rigenerativa
p_mov_no_regen = p_acc + p_roll + p_aero;
p_mov_no_regen (p_mov_no_regen<0) = 0;  %per spiegazioni vedi appunti
% figure
% plot(time_acc, p_acc_no_regen)

p_tot_no_regen = (p_mov_no_regen + p_aux)./eta; %assumendo la stessa efficienza anche per il passaggio batt --> aux

% figure
% plot(time_acc , p_tot_no_regen);
% grid on
% grid minor
% title('potenza istantanea batteria no regen')

E = trapz(t_s, p_tot_no_regen)/3.6e6;
% disp(E_no_regen);
% 
% E_roll = trapz(t_s, p_roll)/ 3.6e6;
% 
% E_aero = trapz(t_s, p_aero)/ 3.6e6;
% 
% E_aux = trapz(t_s, p_aux)/ 3.6e6;
% 
% E = E_no_regen + E_roll + E_aero + E_aux;
% disp(E);  % in kWh !!

end