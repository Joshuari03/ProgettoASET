%% Pulizia variabili e caricamento dati
clearvars
load('JOlogBUS93_16_10_25.mat');
load('JOLogBUS93_ritorno_16_10_25.mat');

figure
plot(PositionAndata.Timestamp, PositionAndata.speed);
title('velocità')

figure
plot(PositionAndata.Timestamp,PositionAndata.hacc);
title('errore posizione')

figure
plot(AccelerationAndata.Timestamp,AccelerationAndata.X);
title('accelerazione')

FFT_accelerationdata = fft(AccelerationAndata.X,[],1);

fs = 20;
N = length(abs(FFT_accelerationdata));
f_GPS = (0:N-1)*(fs/N);


figure
plot(f_GPS, abs(FFT_accelerationdata));
title('FFT accelerazione')

dt = 1/20; %1 fratto la freq di campionamento
a = gradient(PositionAndata.speed, dt); %derivata della velocità

figure
plot(PositionAndata.Timestamp, a);
title('accelerazione ricavata dalla velocità derivando')




FFT_accelerationderivato = fft(a);

fs_GPS = 1;
N = length(abs(FFT_accelerationderivato));
f_GPS = (0:N-1)*(fs_GPS/N);

figure
plot(f_GPS, abs(FFT_accelerationderivato));
title('FFT accelerazione derivata')

