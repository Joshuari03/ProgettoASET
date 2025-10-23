a = a_cleaned;
m = 20e3;
v = speed;
t_gps = Position.Timestamp;
t_acc = Acceleration.Timestamp;


v_interp = interp1(t_gps, v, t_acc, 'linear', 'extrap');
figure
plot(t_gps, v);
figure
plot(t_acc, v_interp);


p_acc = m*a.*v_interp;
figure
plot(t_acc , p_acc);
grid on
grid minor

