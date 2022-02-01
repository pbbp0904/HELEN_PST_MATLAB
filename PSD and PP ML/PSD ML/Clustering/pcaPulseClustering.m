%% CLYC
X = PayloadRadData{2}.pulsedata_b;
Xp = -X(PayloadRadData{2}.isTail==0,:);
Xpp = Xp(1:1000000,:);
[pc, zscores, pcvars] = pca(Xpp,'NumComponents',3);

figure
scatter3(zscores(:,1),zscores(:,2),zscores(:,3));
xlabel('First Principal Component');
ylabel('Second Principal Component');
title('Principal Component Scatter Plot');
axis square
drawnow

% figure
% pcclusters = clusterdata(zscores(:,1:2),'maxclust',9,'linkage','av');
% gscatter(zscores(:,1),zscores(:,2),pcclusters)
% xlabel('First Principal Component');
% ylabel('Second Principal Component');
% title('Principal Component Scatter Plot with Colored Clusters');

%% LYSO
X = PayloadRadData{1}.pulsedata_b;
Xp = -X(PayloadRadData{1}.isTail==0,:);
Xpp = X(1:100000,:);
[pc, zscores, pcvars] = pca(Xpp);

figure
scatter(zscores(:,1),zscores(:,2));
xlabel('First Principal Component');
ylabel('Second Principal Component');
title('Principal Component Scatter Plot');
drawnow

figure
pcclusters = clusterdata(zscores(:,1:2),'maxclust',5,'Distance','minkowski',.1,'linkage','average');
gscatter(zscores(:,1),zscores(:,2),pcclusters)
xlabel('First Principal Component');
ylabel('Second Principal Component');
title('Principal Component Scatter Plot with Colored Clusters');