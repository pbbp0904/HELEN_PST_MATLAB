smoothAmount = 60;
Lat1 = smooth(diff(PayloadEnvData{1}.gpsLats(1:8424)),smoothAmount);
Lat2 = smooth(diff(PayloadEnvData{2}.gpsLats(1:8296)),smoothAmount);
Alt1 = smooth(PayloadEnvData{1}.gpsAlts(2:8424),smoothAmount);
Alt2 = smooth(PayloadEnvData{2}.gpsAlts(2:8296),smoothAmount);
Long1 = smooth(diff(PayloadEnvData{1}.gpsLongs(1:8424)),smoothAmount);
Long2 = smooth(diff(PayloadEnvData{2}.gpsLongs(1:8296)),smoothAmount);

figure()
plot(Lat1,Alt1)
hold on
plot(Lat2,Alt2)

figure()
plot(Long1,Alt1)
hold on
plot(Long2,Alt2)