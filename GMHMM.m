% This file analyze the bearing data using HMM-GMM model
clc; clear;
%% Bearing data processing
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
X_1 = avps(:,1:3);
X_2 = rmss(:,1:3);
X_3 = mv(:,1:3);
%% HMM-GMM training
O = 3; % Number of coefficients in a vector 
T = 23; % Number of vectors in a sequence 
nex = 3; % Number of sequences 
M = 1; % Number of mixtures 
Q = 4; % Number of states 
cov_type = 'full';
data = zeros(O,T,nex);
for i = 1:nex
    data(:,:,i) = [X_1(:,i)';X_2(:,i)';X_3(:,i)'];
end
% initial guess of parameters
prior0 = normalise(rand(Q,1));
transmat0 = mk_stochastic(rand(Q,Q));
if 0
  Sigma0 = repmat(eye(O), [1 1 Q M]);
  % Initialize each mean to a random data point
  indices = randperm(T*nex);
  mu0 = reshape(data(:,indices(1:(Q*M))), [O Q M]);
  mixmat0 = mk_stochastic(rand(Q,M));
else
  [mu0, Sigma0] = mixgauss_init(Q*M, data, cov_type);
  mu0 = reshape(mu0, [O Q M]);
  Sigma0 = reshape(Sigma0, [O O Q M]);
  mixmat0 = mk_stochastic(rand(Q,M));
end
[LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
    mhmm_em(data, prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 20);
[loglik, alpha] = mhmm_logprob_overide(data, prior1, transmat1, mu1, Sigma1, mixmat1);
%% State estimation of bearing 4
data_test = [avps(:,4)'; rmss(:,4)'; mv(:,4)'];
[loglik_test, alpha_test] = mhmm_logprob_overide(data_test, prior1, transmat1, mu1, Sigma1, mixmat1)


