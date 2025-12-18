function [E_tot, E_mot_out, p_acc, p_tot] = Energy (acc_cleaned, speed, time_gps, time_acc)
%time_gps = Position.Timestamp; --> dati presi dal gps
%time_acc = Acceleration.Timestamp; --> dati presi dall'accelerometro


a = acc_cleaned;
m_veicolo = 13e3;
m_persone = 70 * 40; %
m = m_veicolo + m_persone;
v = speed;

t_s = seconds(time_acc - time_acc(1));
g = 9.80665; % accelerazione di gravità
Crr = 0.008; % coefficiente di attrito ruota strada
rho = 1.225; % coefficiente attrito dell'aria
CdA = 8; % area frontale bus per attrito aero
eta = 0.8; % efficienza trasmissione tra batteria e ruote
S = 0.4; %split factor tra freno meccanico e rigenerazione, parametro trovato su tesi

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

%giùstificato su overleaf

%% calcolo potenza istantanea
p_acc = m *a .*v_interp; %p_acc = d/dt Ec

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
p_mot_raw = p_acc + p_roll + p_aero; %se p_acc < 0 ma comunque p_mot > 0 significa che, nonostante il veicolo stia rallentando, 
                                     %il motore sta compensando in parte p_roll + p_aero
                                     %quindi il motore inizia a rigenerare quando p_mot < 0, cioè il veicolo sta rallentando 
                                     %e |d/dt Ec| > |p_roll + p_mot|
p_mot_out = p_mot_raw;
p_mot_out(p_mot_raw<0) = 0;
p_reg = p_mot_raw;
p_reg(p_mot_raw>=0) = 0;
p_reg(p_mot_raw<0) = p_mot_raw(p_mot_raw<0)*S;
% figure
% plot(time_acc, p_acc);
% grid on;
% title('d/dt Ec');

p_tot = (p_mot_out./eta + p_reg.*eta) + p_aux; %assumendo la stessa efficienza sia per batt --> ruote che per ruote --> batt
p_tot_no_regen = (p_mot_out./eta) + p_aux;
% figure
% plot(time_acc , p_tot);
% grid on
% grid minor
% title('potenza istantanea batteria con rigenerazione')

E_tot = trapz(t_s, p_tot)/3.6e6; %in kWh
% disp(E_no_regen);
E_mot_out = trapz(t_s, p_tot_no_regen)/3.6e6;
%
% E_reg = trapz(t_s, p_reg)/3.6e6;
% 
% E_roll = trapz(t_s, p_roll)/ 3.6e6;
% 
% E_aero = trapz(t_s, p_aero)/ 3.6e6;
% 
% E_aux = trapz(t_s, p_aux)/ 3.6e6;

end