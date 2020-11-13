if(~exist("data"))
    data = importRADData("E:\Flight Data\FullPulseTestData\Test1\data");
end

for i=1:length(data)
    a_channel_data(i,:) = round(data(i,:)./(2.^16));
    b_channel_data(i,:) = round(mod(data(i,:),2.^16));
end