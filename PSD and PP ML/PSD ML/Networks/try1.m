function [layers] = try1
layers = [
    sequenceInputLayer(12000)
    
    convolution1dLayer(3,128,Padding="causal")
    batchNormalizationLayer
    reluLayer
    
    convolution1dLayer(3,128,Padding="causal")
    batchNormalizationLayer
    reluLayer
    
    convolution1dLayer(3,128,Padding="causal")
    batchNormalizationLayer
    reluLayer
    
    convolution1dLayer(3,128,Padding="causal")
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(2)
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];
end

