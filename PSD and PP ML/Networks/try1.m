function [layers] = try1
layers = [
    featureInputLayer(32,"Name","featureinput")
    
    convolution1dLayer(5,128)
    batchNormalizationLayer
    reluLayer
    maxPooling1dLayer(2)
    
    convolution1dLayer(5,128)
    batchNormalizationLayer
    reluLayer
    maxPooling1dLayer(2)
    
    convolution1dLayer(5,128)
    batchNormalizationLayer
    reluLayer
    maxPooling1dLayer(2)
    
    convolution1dLayer(5,128)
    batchNormalizationLayer
    reluLayer
    maxPooling1dLayer(2)
    
    fullyConnectedLayer(6)
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];
end

