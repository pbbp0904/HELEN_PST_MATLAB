%% CLYC
X = PayloadRadData{2}.pulsedata_b;
Xp = -X(PayloadRadData{2}.isTail==0,:);
Xpp = Xp(500000:510000,:);

rng('default');
[cidx, ctrs] = kmeans(Xpp,3,'dist','corr','rep',10,'disp','final');
figure
for c = 1:4
subplot(2,2,c);
plot(0:20:620,Xpp((cidx == c),:)');
axis tight
ylim([-300 3000])
end
sgtitle('K-Means Clustering of Profiles');


%% LYSO
X = PayloadRadData{3}.pulsedata_b;
Xp = -X(PayloadRadData{3}.isTail==0,:);
Xpp = Xp(500000:550000,:);

rng('default');
[cidx, ctrs] = kmeans(Xpp,9,'dist','corr','rep',10,'disp','final');
figure
for c = 1:9
subplot(3,3,c);
plot(0:20:620,Xpp((cidx == c),:)');
axis tight
ylim([-300 3000])
end
sgtitle('K-Means Clustering of Profiles');


