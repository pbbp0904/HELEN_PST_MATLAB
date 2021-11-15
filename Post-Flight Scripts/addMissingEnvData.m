function [PayloadEnvData] = addMissingEnvData(PayloadEnvData, maxPayload)
% Get sizes of each payload's data
s = ones(1,maxPayload);
for payload = 1:maxPayload
    s(payload) = height(PayloadEnvData{payload});
end
% Get max index of s
[~,i] = max(s);
% For each payload
for payload = 1:maxPayload
    % Check if data is absent
    if s(payload) == 0
        % Add 1 row of missing values
        PayloadEnvData{payload} = PayloadEnvData{i}(1,:);
        for ind = 1 : width(PayloadEnvData{payload})
            PayloadEnvData{payload}.(ind) = missing; 
        end
    end
end
end

