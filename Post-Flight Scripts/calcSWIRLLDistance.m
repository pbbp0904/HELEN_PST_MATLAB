function [xEast, yNorth, zUp] = calcSWIRLLDistance(lats, longs, alts)
SWIRLL = [ 34.72498, -86.64615, 210];

if length(lats)>1 && length(longs)>1 && length(alts)>1
    [xEast,yNorth,zUp] = latlon2local(lats,longs,alts,SWIRLL);
else
    xEast = missing;
    yNorth = missing;
    zUp = missing;
end

end
