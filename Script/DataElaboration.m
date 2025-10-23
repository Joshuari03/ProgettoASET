%% Pulizia variabili e caricamento dati
clearvars
%load('JOlogBUS93_16_10_25.mat');
%load('JOLogBUS93_ritorno_16_10_25.mat');
load("Miki_973_A_1.mat");
%load("973 ritorno linate-forlanini m4.mat");
%% data for plots
time_acc = Acceleration.Timestamp;
time_GPS = Position.Timestamp;
speed = Position.speed;
acc = Acceleration.Y;
acc = acc - mean(acc);
%% accelerometro

A = fft(acc);

fs_acc = 20;
N = length(abs(A));
f_acc = (0:N-1)*(fs_acc/N);

if mod(length(A),2)==0
    half_len = (length(A))/2;
elseif mod(length(A),2)~=0
    half_len = (length(A)+1)/2;
end
A_half = A(1:half_len);
f_cut = 4;
A_half(round(f_cut * length(A_half)/ fs_acc):end) = 0;

if mod(length(A),2)==0
    A_rec = [A_half; 0; conj(A_half(end:-1:2))];
elseif mod(length(A),2)~=0
    A_rec = [A_half; conj(A_half(end:-1:2))];
end

a_cleaned = ifft ((A_rec));

%% derivata velocità

dt = 1/20; %1 fratto la freq di campionamento
dv = gradient(speed, dt); %derivata della velocità


DV = fft(dv);


fs_GPS = 1;
N = length(abs(DV));
f_GPS = (0:N-1)*(fs_GPS/N);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
