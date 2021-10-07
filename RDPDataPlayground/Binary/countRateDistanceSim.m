

countRate = 313;  % counts/s
flightTime = 100000;

rs = sort(flightTime*rand(1,countRate*flightTime));

histogram(diff(rs),1000)