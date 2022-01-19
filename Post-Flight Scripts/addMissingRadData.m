function [PayloadRadData] = addMissingRadData(PayloadRadData, maxPayload)
% Get sizes of each payload's data
s = ones(1,maxPayload);
for payload = 1:maxPayload
    s(payload) = height(PayloadRadData{payload});
end
% Get max index of s
[~,i] = max(s);
% For each payload
for payload = 1:maxPayload
    % Check if data is absent
    if s(payload) == 0
        % Add 1 row of missing values
        PayloadRadData{payload} = PayloadRadData{i}(1,:);
        for ind = 1 : width(PayloadRadData{payload})
            PayloadRadData{payload}.(ind) = NaN;
        end
    end
end
end