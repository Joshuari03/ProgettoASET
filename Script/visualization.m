%% plot velocità GPS

figure
plot(time_GPS, speed*3.6);
title('velocità')
grid on
grid minor

%% plot errore GPS
figure
plot(time_GPS,PositionAndata.hacc);
title('errore posizione')

%% plot accelerazione grezza accelerometro
figure
plot(time_acc, acc);
title('accelerazione grezza')
grid on
grid minor

%% plot FFT accelerazione
figure
plot(f_acc, abs(A));
title('FFT accelerazione')

%% plot accelerazione ricavata dalla velocità derivando
figure
plot(time_GPS, dv);
title('accelerazione ricavata dalla velocità derivando')

%% plot FFT accelerazione derivata
figure
plot(f_GPS, abs(DV));
title('FFT accelerazione derivata') 

%% plot accelerazione pulita
figure
plot(time_acc, a_cleaned);
title('accelerazione pulita con FFT')
grid on
grid minor
%% plot accelerazione grezza + media mobile
figure
plot(time_acc, a_mmean);
title('accelerazione grezza + media mobile')
grid on
grid minor
%%
v = D_and.Position.speed(1);
a = D_and.Acceleration.
v_interp = interp1(time_gps, v, time_acc, 'linear', 'extrap');
p_acc = m *a .*v_interp;
