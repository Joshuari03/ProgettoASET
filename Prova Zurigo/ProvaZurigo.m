clearvars

T = readtable('B208_2022-05-12_13-24-36_2022-05-12_18-39-08.csv');
lat = T.gnss_latitude * 180/pi;
lon = T.gnss_longitude * 180/pi;
course = T.gnss_course;
p_tot = T.electric_powerDemand;
t = datetime(T.time_iso,'InputFormat','yyyy-MM-dd''T''HH:mm:ss''Z''');

t0 = t(1);
dt = seconds((t-t0));   % vettore in secondi
figure
geoscatter(lat, lon, 20, course, 'filled');
colorbar

figure;
plot(T.electric_powerDemand);


E_tot = trapz(dt, p_tot)/3.6e6; %in kWh
% Calculate the total distance traveled
distances = deg2km(distance(lat(1:end-1), lon(1:end-1), lat(2:end), lon(2:end)));
distances(isnan(distances)) = 0;
total_distance = sum((distances));


E_tot_per_km = E_tot / total_distance;