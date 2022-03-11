%% CLYC

%% Channel A
X = -PayloadRadData{2}.pulsedata_a;
X = X(PayloadRadData{2}.isTail==0,:);
X = X(1:1000,:);
Z = linkage(X,'average','cosine');
[H,T] = dendrogram(Z,20);

figure()
h1=plot(X(T==6|T==7|T==19|T==18|T==14|T==15|T==16|T==17|T==20,:)','k');
hold on
h2=plot(X(T==5|T==10|T==12|T==13|T==8|T==2|T==4|T==9,:)','g');
h3=plot(X(T==3,:)','b');
h4=plot(X(T==1|T==11,:)','r');

legend([h4(1),h3(1),h2(1),h1(1)],"1|11","3","5|10|12|13|8|2|4|9","6|7|19|18|14|15|16|17|20");


%% Channel B
X = -PayloadRadData{2}.pulsedata_b;
X = X(PayloadRadData{2}.isTail==0,:);
X = X(1:1000,:);
Z = linkage(X,'average','cosine');
[~,T] = dendrogram(Z,20);

figure()
hold on
plot(X(T==5|T==13|T==18|T==12,:)','k')
plot(X(T==1|T==4|T==19|T==8|T==16|T==3|T==7|T==9|T==6,:)','g')
plot(X(T==14|T==2|T==20,:)','b')
plot(X(T==11|T==10|T==15|T==17,:)','r')



%% Channel A with tails
X = -PayloadRadData{2}.pulsedata_a;
%X = X(PayloadRadData{2}.isTail==0,:);
X = X(1:1000,:);
Z = linkage(X,'average','cosine');
[~,T] = dendrogram(Z,20);

figure()
h1=plot(X(T==9|T==19|T==20|T==14|T==16,:)','k');
hold on
h5=plot(X(T==2|T==4|T==17|T==3,:)','m');
h2=plot(X(T==5|T==10|T==12|T==13|T==8|T==2|T==4|T==9,:)','g');
h3=plot(X(T==6|T==18|T==12|T==7|T==15|T==10|T==5,:)','b');
h4=plot(X(T==1,:)','r');
h4=plot(X(T==11,:)','color',[1,0.3,0.2]);


%% Channel B with tails
X = -PayloadRadData{2}.pulsedata_b;
%X = X(PayloadRadData{2}.isTail==0,:);
X = X(1:1000,:);
Z = linkage(X,'average','cosine');
[~,T] = dendrogram(Z,20);

figure()
hold on
plot(X(T==5|T==13|T==18|T==12,:)','k')
plot(X(T==1|T==4|T==19|T==8|T==16|T==3|T==7|T==9|T==6,:)','g')
plot(X(T==14|T==2|T==20,:)','b')
plot(X(T==11|T==10|T==15|T==17,:)','r')


%% LYSO

%% Channel A
X = -PayloadRadData{3}.pulsedata_a;
X = X(PayloadRadData{3}.isTail==0,:);
X = X(1:1000,:);
Z = linkage(X,'average','cosine');
[~,T] = dendrogram(Z,10);

figure()
hold on
plot(X(T==7|T==8|T==9,:)','k')
plot(X(T==1|T==3,:)','g')
plot(X(T==2|T==4,:)','b')
plot(X(T==6|T==10|T==5,:)','r')


%% Channel B
X = -PayloadRadData{3}.pulsedata_b;
X = X(PayloadRadData{3}.isTail==0,:);
X = X(1:1000,:);
Z = linkage(X,'average','cosine');
[~,T] = dendrogram(Z,10);

figure()
hold on
plot(X(T==7|T==4|T==9|T==6|T==5|T==10|T==9|T==8,:)','k')
plot(X(T==3,:)','g')
plot(X(T==1,:)','b')
plot(X(T==2,:)','r')
