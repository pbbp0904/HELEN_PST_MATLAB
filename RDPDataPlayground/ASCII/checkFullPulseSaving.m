if(~exist("data"))
    data = importRADData("E:\Flight Data\FullPulseTestData\Test1\data");
end

for i=1:length(data)
    a_channel_data(i,1:2) = data(i,1:2);
    b_channel_data(i,1:2) = data(i,1:2);
    for j = 3:34
        if bitshift(int32(data(i,j)),-16,'int32')>2^13
            a_channel_data(i,j) = 2^14-bitshift(int32(data(i,j)),-16,'int32');
        else
            a_channel_data(i,j) = -bitshift(int32(data(i,j)),-16,'int32');
        end
        if round(mod(data(i,j),2.^16))>2^13
            b_channel_data(i,j) = 2^14-round(mod(data(i,j),2.^16));
        else
            b_channel_data(i,j) = -round(mod(data(i,j),2.^16));
        end
    end
end

% for i = 1:1000
%     plot(a_channel_data(i,3:34))
%     ylim([0,1.1*max(a_channel_data(i,3:34))])
%     pause
% end

a_max = max(a_channel_data(:,3:34)');
a_sum = sum(a_channel_data(:,3:34)');
a_mean = mean(a_channel_data(:,3:34));

b_max = max(b_channel_data(:,3:34)');
b_sum = sum(b_channel_data(:,3:34)');
b_mean = mean(b_channel_data(:,3:34));

