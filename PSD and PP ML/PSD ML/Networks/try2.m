function [layers] = try2
layers = [
    featureInputLayer(29,"Name","featureinput")
    fullyConnectedLayer(32,"Name","fc_1",'WeightsInitializer','narrow-normal','BiasInitializer','narrow-normal')
    reluLayer("Name","relu_1")
    fullyConnectedLayer(32,"Name","fc_2",'WeightsInitializer','narrow-normal','BiasInitializer','narrow-normal')
    reluLayer("Name","relu_2")
    fullyConnectedLayer(32 ,"Name","fc_3",'WeightsInitializer','narrow-normal','BiasInitializer','narrow-normal')
    reluLayer("Name","relu_3")
    fullyConnectedLayer(2 ,"Name","fc_4",'WeightsInitializer','narrow-normal','BiasInitializer','narrow-normal')
    reluLayer("Name","relu_4")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];
end

