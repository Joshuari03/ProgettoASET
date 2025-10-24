a = a_cleaned;
m = 20e3;
v = speed;
t_gps = Position.Timestamp;
t_acc = Acceleration.Timestamp;
t_s = seconds(t_acc - t_acc(1));

v_interp = interp1(t_gps, v, t_acc, 'linear', 'extrap');
% figure
% plot(t_gps, v);
figure
plot(t_acc, v_interp*3.6);
grid on
grid minor
title('velocità interpolata km/h')


p_acc = m*a.*v_interp;

figure
plot(t_acc , p_acc);
grid on
grid minor
title('potenza istantanea')



%% calcolo energia
p_acc_no_regen = p_acc;
for k=1:1:length(p_acc)
    if p_acc(k)<0
        p_acc_no_regen(k)=0;
    end
end

figure
plot(t_acc, p_acc_no_regen)

E_no_regen = trapz(t_s, p_acc_no_regen)/ 3.6e6;
disp(E_no_regen);