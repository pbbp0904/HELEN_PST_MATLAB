function [PayloadRadData] = findMissedSeconds(PayloadRadData)

for i = 1:length(PayloadRadData)
    
    dp = diff(PayloadRadData{i}.pps_time);
    dpz = dp(dp~=0);
    mdp = median(dpz);
    
    x = find(dpz>10*mdp & (dpz<1.5*mdp));

    PayloadRadData{i}.Properties.UserData.missedSecondLocations = find(dp>10*mdp & (dp<1.5*mdp));
    PayloadRadData{i}.Properties.UserData.missedSecondDurations = dpz(x)./dpz(x-1);
    
end


end