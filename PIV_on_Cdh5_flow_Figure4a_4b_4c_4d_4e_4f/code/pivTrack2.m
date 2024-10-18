function [ vxMat,vyMat] = pivTrack2( img1,img2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[row,col]       =   size(img1);
probeInterval   =   20;
probeX          =   linspace(1,col,round(col/probeInterval));
probeY          =   linspace(1,row,round(row/probeInterval));
[X,Y]           =   meshgrid(probeX,probeY);
ProbePos        =   [reshape(X,[],1),reshape(Y,[],1)];



[~,PredictVel,~]=pivTrack(img1,img2,ProbePos,th);
%vxMat        =   reshape(PredictVel(:,1),length(probeY),length(probeX));
%vyMat        =   reshape(PredictVel(:,2),length(probeY),length(probeX));

FX = TriScatteredInterp(ProbePos(:,1),ProbePos(:,2),PredictVel(:,1));
FY = TriScatteredInterp(ProbePos(:,1),ProbePos(:,2),PredictVel(:,2));
[xq,yq] = meshgrid(1:1:col, 1:1:row);
vxMat           =  FX(xq,yq);
vyMat           =  FY(xq,yq);




end

