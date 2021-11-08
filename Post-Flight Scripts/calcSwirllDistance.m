function [xEast, yNorth, zUp] = calcSwirllDistance(lats,longs,alts)

origin = [ 34.72498, -86.64615, 210];
[xEast,yNorth,zUp] = latlon2local(lats,longs,alts,origin);

%distance = sqrt(xEast^2 + yNorth^2 + zUp^2);

end
