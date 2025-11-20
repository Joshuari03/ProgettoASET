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
 E_tot = NaN(size(D,1), 1); %con rigenerazione
 E_no_regen = NaN(size(D,1), 1); %senza rigenerazione
%% data for plots

for i=1:size(D,1)

    time_acc = D(i).Acceleration.Timestamp;
    time_GPS = D(i).Position.Timestamp;
    speed = D(i).Position.speed;
    acc = D(i).Acceleration.Y;
    acc = acc - mean(acc);

    %RICHIAMARE ENERGY IN QUESTO SCRIPT
    %% accelerometro

    A = fft(acc);

    fs_acc = 20; %deciso da noi durante la raccolta dati
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
   
    N = 10;
    b = ones(1, N) / N;
    a = 1;
    a_filt = filtfilt(b, a, acc); %media mobile senza introduzione di ritardo
    %% derivata velocità

    dt = 1/20; %1 fratto la freq di campionamento
    dv = gradient(speed, dt); %derivata della velocità


    DV = fft(dv);


    fs_GPS = 1;
    N = length(abs(DV));
    f_GPS = (0:N-1)*(fs_GPS/N);
    
    %% richiamo energy
    [E_tot(i), E_no_regen(i)] = Energy(a_filt, speed, time_GPS, time_acc); %in kWh
end
