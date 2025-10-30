%% Pulizia variabili e caricamento dati
clearvars
%<<<<<<< Updated upstream
D =[load("Miki_973_A_1.mat");
    load("MS_973_A_2.mat");
    load("FA_973_A_2.mat");
    load("JO_973_A_2.mat");
    load("FA_973_R_1.mat");
    load("MS_973_R_2.mat");
    load("FA_973_R_2.mat");
    load("JO_973_R_2.mat")];

%<<<<<<< Updated upstream
%=======
%=======
%>>>>>>> Stashed changes
%>>>>>>> Stashed changes
%% data for plots

for i=1:size(D,1)
    
    time_acc = D(i).Acceleration.Timestamp;
    time_GPS = D(i).Position.Timestamp;
    speed = D(i).Position.speed;
    acc = D(i).Acceleration.Y;
    acc = acc(i) - mean(acc(i));

end %ESTENDERE FOR E RICHIAMARE ENERGY IN QUESTO SCRIPT
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
f_cut = 2;
A_half(round(f_cut * length(A_half)/ fs_acc):end) = 0;

if mod(length(A),2)==0
    A_rec = [A_half; 0; conj(A_half(end:-1:2))];
elseif mod(length(A),2)~=0
    A_rec = [A_half; conj(A_half(end:-1:2))];
end

a_cleaned = ifft ((A_rec));
a_mmean = movmean(acc, 10);
%% derivata velocità

dt = 1/20; %1 fratto la freq di campionamento
dv = gradient(speed, dt); %derivata della velocità


DV = fft(dv);


fs_GPS = 1;
N = length(abs(DV));
f_GPS = (0:N-1)*(fs_GPS/N);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
