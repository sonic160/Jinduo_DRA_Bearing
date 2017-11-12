clc;
clear;
%This is for the feature classification of four bearings
load('avpresults.mat')% matlab20170803.mat is the dataset for four bearings in 35days
load('RMSvalues.mat')
%mnum=xlsread('meanof bearings');
load('meanofbearings');
% plot3(avp(:,1),Meanvalue(:,1),-meanvba(:,1),'O');
% hold on
% grid on
% plot3(avp(:,2),Meanvalue(:,2),-meanvba(:,2),'^');
% plot3(avp(:,3),Meanvalue(:,3),-meanvba(:,3),'d');
% legend('Bearing1','Bearing2','Bearing3');
% xlabel('Average power');
% ylabel('RMS');
% zlabel('Mean value')

interavp=max(max(avp))-min(min(avp));
avps=(avp-min(min(avp)))/interavp;
interrmss=max(max(Meanvalue))-min(min(Meanvalue));
rmss=(Meanvalue-min(min(Meanvalue)))/interrmss;
% intermeannumber=max(mnum(:,1:2:end))-min(mnum(:,1:2:end));
% mv=(mnum(:,1:2:end)-repmat(min(mnum(:,1:2:end)),length(mnum),1))./intermeannumber;
meanvba = -meanvba;
intermeannumber=max(max(meanvba))-min(min(meanvba));
mv=(meanvba-min(min(meanvba)))/intermeannumber;
plot3(avps(:,1),rmss(:,1),mv(:,1),'O');
hold on
grid on
plot3(avps(:,2),rmss(:,2),mv(:,2),'^');
plot3(avps(:,3),rmss(:,3),mv(:,3),'d');
legend('Bearing1','Bearing2','Bearing3');
xlabel('Average power');
ylabel('RMS');
zlabel('Mean value')
% This is for kmeans clustering analysis
k=4;% this is the number of states
X1=reshape(avps(:,1:3),69,1);
X2=reshape(rmss(:,1:3),69,1);
X3=reshape(mv(:,1:3),69,1);
M=[X1 X2 X3];
[Idx1,C,sumd,D]=kmeans(M,k,'dist','sqEuclidean','rep',10)

for i = 1:3
    index(:,i) = Idx1(23*(i-1)+1:23*(i-1)+23)
end




