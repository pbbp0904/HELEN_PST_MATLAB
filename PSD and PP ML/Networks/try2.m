function [layers] = try1
layers = [
    featureInputLayer(32,"Name","featureinput")
    fullyConnectedLayer(200,"Name","fc_1")
    reluLayer("Name","relu_1")
    fullyConnectedLayer(20,"Name","fc_2")
    reluLayer("Name","relu_2")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];
end

