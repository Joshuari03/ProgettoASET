a = a_cleaned;
m = 20e3;
v = speed;
t_gps = Position.Timestamp;
t_acc = Acceleration.Timestamp;
t_s = seconds(t_acc - t_acc(1));
g = 9.80665; % accelerazione di gravità
Crr = 0.008; % coefficiente di attrito ruota strada
rho = 1.225; % coefficiente attrito dell'aria
CdA = 8; % area frontale bus per attrito aero
eta = 0.8; % efficienza trasmissione tra batteria e ruote

v_interp = interp1(t_gps, v, t_acc, 'linear', 'extrap');
% figure
% plot(t_gps, v);
figure
plot(t_acc, v_interp*3.6);
grid on
grid minor
title('velocità interpolata km/h')

%% Potenza servizi ausiliari
p_aux = 5000;

%% calcolo potenza istantanea
p_acc = m *a .*v_interp;

figure
plot(t_acc , p_acc);
grid on
grid minor
title('potenza istantanea')

%% calcolo potenza attrito ruota gomma
p_roll = m * g * Crr .* v_interp;

%% calcolo potenza attrito aerodinamico
p_aero   = 0.5 * rho * CdA .* v_interp.^3;

%% calcolo energia
p_acc_no_regen = p_acc;
for k=1:1:length(p_acc)
    if p_acc(k)<0
        p_acc_no_regen(k)=0;
    end
end

% figure
% plot(t_acc, p_acc_no_regen)

p_tot_raw = p_acc_no_regen + p_roll + p_aero + p_aux;
p_battery = p_tot_raw./eta;

E = trapz(t_s, p_battery)/ 3.6e6;
% disp(E_no_regen);
% 
% E_roll = trapz(t_s, p_roll)/ 3.6e6;
% 
% E_aero = trapz(t_s, p_aero)/ 3.6e6;
% 
% E_aux = trapz(t_s, p_aux)/ 3.6e6;
% 
% E = E_no_regen + E_roll + E_aero + E_aux;
disp(E);  % in kWh !!