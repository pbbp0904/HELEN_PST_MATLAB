tic
DirectoryLocation = "D:/Flight Data/Flight 3/3-Processed Data/";
load(strcat(DirectoryLocation,"Rad-Env_Data.mat"))
toc

tic
[firstPulseEvent,firstPulseSecond_FPGA,firstPulseSecond_ENV] = getTimingStart(PayloadRadData,PayloadEnvData);
toc