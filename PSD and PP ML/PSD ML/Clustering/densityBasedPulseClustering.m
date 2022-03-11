%% CLYC

X = PayloadRadData{2}.pulsedata_b;
Xp = -X(PayloadRadData{2}.isTail==0,:);
Xpp = Xp(1:10000,:);
[pc, zscores, pcvars] = pca(Xpp,'NumComponents',2);
X = zscores(:,1:2);
[n,p] = size(X);

idx = dbscan(X,70,20);

gscatter(X(:,1),X(:,2),idx);
title('Particle Discrimination CLYC Channel A')

figure()
X = PayloadRadData{2}.pulsedata_a;
Xp = -X(PayloadRadData{2}.isTail==0,:);
Xpp = Xp(1:10000,:);
[pc, zscores, pcvars] = pca(Xpp,'NumComponents',2);
X = zscores(:,1:2);
[n,p] = size(X);

idx = dbscan(X,750,70);

gscatter(X(:,1),X(:,2),idx);
title('Particle Discrimination CLYC Channel A')


%% LYSO
figure()
X = PayloadRadData{3}.pulsedata_b;
Xp = -X(PayloadRadData{3}.isTail==0,:);
Xpp = Xp(1:10000,:);
[pc, zscores, pcvars] = pca(Xpp,'NumComponents',2);
X = zscores(:,1:2);
[n,p] = size(X);

idx = dbscan(X,70,20);

gscatter(X(:,1),X(:,2),idx);
title('Particle Discrimination')