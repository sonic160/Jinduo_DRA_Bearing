% This file does clustering of the bearing features using Gaussian mixture
% models
clc; clear;
% Load bearing features
load('avpresults.mat');
load('RMSvalues.mat');
load('meanofbearings');
% Pre-process the features
interavp = max(max(avp))-min(min(avp));
avps = (avp-min(min(avp)))/interavp;
interrmss = max(max(Meanvalue))-min(min(Meanvalue));
rmss = (Meanvalue-min(min(Meanvalue)))/interrmss;
meanvba = -meanvba;
intermeannumber = max(max(meanvba))-min(min(meanvba));
mv = (meanvba-min(min(meanvba)))/intermeannumber;
% The three features
X1 = reshape(avps(:,1:3),69,1);
X2 = reshape(rmss(:,1:3),69,1);
X3 = reshape(mv(:,1:3),69,1);
X = [X1,X2,X3]; % X is the data matrix
% GMM clustering
options = statset('MaxIter',1000);
GMModel = fitgmdist(X,4,'Options',options,'RegularizationValue',1e-4); % Fit the GMM
idx = cluster(GMModel,X); % Doing the clustering
P = posterior(GMModel,X); % Posterior probabilities at each time
% Generate psuedo test data
