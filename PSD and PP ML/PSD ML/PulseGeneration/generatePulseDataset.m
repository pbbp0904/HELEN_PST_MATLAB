
% Set sample times
t = 0:20:31*20;

% Set number of pulses to generate of each type
n = 6000;

% Gamma pulse constants taken from (Pulse Characteristics of CLYC and
% Piled-up Neutron–gamma Discrimination using a Convolutional Neural Net)
% Han et al. 2022
t1g=7.35; t2g=918; t3g=10.2; t4g=43;
t1gd=0.05; t2gd=10; t3gd=0.02; t4gd=0.5;
A1g=15.38; A2g=0.30; A3g=6.69; A4g=0.93;
A1gd=4.16; A2gd=0.03; A3gd=2.34; A4gd=0.18;

% Neutron pulse constants taken from (Pulse Characteristics of CLYC and
% Piled-up Neutron–gamma Discrimination using a Convolutional Neural Net)
% Han et al. 2022
t1n=17.8; t2n=3193; t3n=570; t4n=1;
t1nd=0.02; t2nd=10; t3nd=10; t4nd=0;
A1n=1.66; A2n=0.35; A3n=0.62; A4n=0;
A1nd=0.16; A2nd=0.03; A3nd=0.04; A4nd=0;


% Combine constants and set measurement parameters
ti = [t1g, t2g, t3g, t4g];
tid = [t1gd, t2gd, t3gd, t4gd];
Ai = [A1g, A2g, A3g, A4g];
Aid = [A1gd, A2gd, A3gd, A4gd];
gammaGain = 10;
gammaGainDiff = 5;
gammaNoisePercentage = 10;

% Make gamma pulses
gammaPulses = makePulses(t,n,ti,tid,Ai,Aid,gammaGain,gammaGainDiff,gammaNoisePercentage);


% Combine constants and set measurement parameters
ti = [t1n, t2n, t3n, t4n];
tid = [t1nd, t2nd, t3nd, t4nd];
Ai = [A1n, A2n, A3n, A4n];
Aid = [A1nd, A2nd, A3nd, A4nd];
neutronGain = 1;
neutronGainDiff = 0.5;
neutronNoisePercentage = 5;

% Make neutron pulses
neutronPulses = makePulses(t,n,ti,tid,Ai,Aid,neutronGain,neutronGainDiff,neutronNoisePercentage);

% Plot first 1000 of each type of pulse
figure()
plot(gammaPulses(:,1:1000),'Blue')
hold on
plot(neutronPulses(:,1:1000),'Red')

% Make input data and output data for ML
inputData = [gammaPulses(4:32,:), neutronPulses(4:32,:)];
outputData = repmat("G",1,n);
outputData(1, n+1:2*n) = repmat("N",1,n);
outputData = categorical(outputData);

% Shuffle dataset
ordering = randperm(2*n);
inputData = inputData(:,ordering)';
outputData = outputData(:,ordering)';

% Create validation data
inputValidation = inputData(round(0.8*2*n)+1:2*n,:);
outputValidation = outputData(round(0.8*2*n)+1:2*n,:);
inputData(round(0.8*2*n)+1:2*n,:) = [];
outputData(round(0.8*2*n)+1:2*n,:) = [];


%%
% Function to make pulses
function pulses = makePulses(t,n,ti,tid,Ai,Aid,gain,gainDiff,noisePercentage)
    t = t';
    
    % Generate gaussian time parameters
    t1 = tid(1).*randn(1,n) + ti(1);
    t2 = tid(2).*randn(1,n) + ti(2);
    t3 = tid(3).*randn(1,n) + ti(3);
    t4 = tid(4).*randn(1,n) + ti(4);
    
    % Generate gaussian gain parameters
    A1 = Aid(1).*randn(1,n) + Ai(1);
    A2 = Aid(2).*randn(1,n) + Ai(2);
    A3 = Aid(3).*randn(1,n) + Ai(3);
    A4 = Aid(4).*randn(1,n) + Ai(4);
    
    % Generate random overall gains
    A = gainDiff*randn(1,n) + gain;
    A(A<0.1) = 0.1;
    
    % Make pulses
    pulses = A.*(-A1.*exp(-t./t1) + A2.*exp(-t./t2) + A3.*exp(-t./t3) + A4.*exp(-t./t4));
    
    % Add noise
    noiseSigma = noisePercentage/100 * pulses;
    noise = noiseSigma .* randn(length(t), n);
    pulses = pulses + noise;
    
    % Adjust max and min of pulse
    pulses(pulses<0) = 0;
    pulses(pulses>1) = 1;
    pulses = pulses./max(pulses,[],1);
    
    % Find pulses completly outside range
    outidx = sum(pulses(4:32,:)==1)>20;
    pulses(:,outidx) = [];
    
    % Recursively generate new pulses
    if width(pulses)~=n
        pulses(:,width(pulses)+1:n) = makePulses(t',n-width(pulses),ti,tid,Ai,Aid,gain,gainDiff,noisePercentage);
    end

end