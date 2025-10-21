
%% plot vari

figure
plot(time_GPS, speed*3.6);
title('velocità')
grid on
grid minor

% figure
% plot(time_GPS,PositionAndata.hacc);
% title('errore posizione')

figure
plot(time_acc, acc);
title('accelerazione')
grid on
grid minor

figure
plot(f_acc, abs(A));
title('FFT accelerazione')

figure
plot(time_GPS, dv);
title('accelerazione ricavata dalla velocità derivando')

figure
plot(f_GPS, abs(DV));
title('FFT accelerazione derivata') 

figure
plot(time_acc, a_cleaned);
title('Accelerazione pulita')
grid on
grid minor