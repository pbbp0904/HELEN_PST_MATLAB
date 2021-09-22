% HELEN EFM Data to E-Field
%clear; 
clc; close all; format long

% Setup
disp('Setting up...');
Ks = setConstants();


% Whole test
%dataStart = 89000;
%dataFinish = 110500;

% 3000 volt test
dataStart = 103200;
dataFinish = 105699;

% 5000 volt test
%dataStart = 107700;
%dataFinish = 108700;



data = csvread('EFMTestData.txt',dataStart,0,[dataStart,0,dataFinish,14]);



% Putting data into variables
a = []; m = []; eCalc = [];
time = 0:Ks.samplePeriod:(dataFinish-dataStart)*Ks.samplePeriod;
v = ((data(:,2)-mean(data(:,2)))*Ks.ADCRange/Ks.ADCResolution)';
a(:,1) = data(:,6)*Ks.AccelRange/Ks.AccelResolution;
a(:,2) = data(:,7)*Ks.AccelRange/Ks.AccelResolution;
a(:,3) = data(:,8)*Ks.AccelRange/Ks.AccelResolution;
m(:,1) = (data(:,13)-mean(data(:,13)))*Ks.MagRange/Ks.MagResolution;
m(:,2) = (data(:,12)-mean(data(:,12)))*Ks.MagRange/Ks.MagResolution;
m(:,3) = (data(:,14)-mean(data(:,14)))*Ks.MagRange/Ks.MagResolution;

% Plotting measured values
disp('Plotting measurements...');
plotMeasurements(time, v, a, m);

% Calculating electric field from data
disp('Calculating electric field...');
eCalc = [eCalc; calculateEField(v, a, m, Ks)];

disp('Done!');