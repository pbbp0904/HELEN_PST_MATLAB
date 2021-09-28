%tic
%DirectoryLocation = "D:/Flight Data/Flight 3/3-Processed Data/";
%load(strcat(DirectoryLocation,"Rad-Env_Data.mat"))
%toc

%% Todo
%A2 Rad
%Identify CLYC pulse tails

%A2 Env
%Convert resistances into temperatures

%A3 
%Find second of each event
%Check for missed seconds
%Add environmental data to radiation event table
%Combine all payload radiation tables into 1 table