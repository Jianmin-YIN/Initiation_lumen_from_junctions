fileName='./E4M3_sta_crop.tif';

reso=0.17;
amp=10;
pix_amp=2`;

CB=1/reso;


for T1=7

T2=9;
Img1=uint8(imread(fileName,T1*2-1));
Img2=uint8(imread(fileName,T2*2-1));
VeloMapX=zeros(size(Img1));
VeloMapY=zeros(size(Img1)); 


level = graythresh(Img1);
Img1_gau=imgaussfilt(Img1,1);
BW2 = imbinarize(Img1_gau,level*1.6);
%imshow(BW2)

STATS = regionprops(BW2, 'Centroid','Area','PixelList');
Areas=cat(1,STATS.Area);
[~,index]=max(Areas);
Apical_list=STATS(index).PixelList;
Centroid=STATS(index).Centroid;

[x,y]=find(BW2==1);
Centroid=[mean(y),mean(x)];

BW3=false(size(BW2));
idx=sub2ind(size(BW2),Apical_list(:,2),Apical_list(:,1));
BW3(idx)=true;



ProbeNum=40;


probeX          =   linspace(20,300,ProbeNum);
probeY          =   linspace(20,120,ProbeNum);
[X,Y]           =   meshgrid(probeX,probeY);
ProbePos        =   [reshape(round(X),[],1),reshape(round(Y),[],1)];



% 
ProbePos2=[];
[r1,c1]=size(ProbePos);
for i=1:1:r1
if BW2(round(ProbePos(i,2)),round(ProbePos(i,1)))==1
    ProbePos2=[ProbePos2;ProbePos(i,:)];
end
end


[PredictPos,PredictVel,Credibility]=pivTrack(Img1,Img2,ProbePos,12); % PredictPos is in the form of [x1,y1;x2,y2];PredictVel is in the form of [vx1,vy1;vx2,vy2];In Credibility1 means reliable, 0 is not
Xp   =  ProbePos(:,1);  
Yp   =  ProbePos(:,2);
VX  =   PredictVel(:,1);
VY  =   PredictVel(:,2);





idx_Vel=sub2ind(size(BW3),Y,X);
[r1,c1]=size(BW3);
[Xq,Yq] = meshgrid(1:1:c1,1:1:r1);

VXR=reshape(VX,size(X));
VYR=reshape(VY,size(X));

MapX=interp2(X,Y,VXR,Xq,Yq);
MapY=interp2(X,Y,VYR,Xq,Yq);


MapX(BW2==0)=0;
MapY(BW2==0)=0;

MapX(isnan(MapX))=0;
MapY(isnan(MapY))=0;




VeloMapX=VeloMapX+MapX;
VeloMapY=VeloMapY+MapY;
MapY=zeros(size(BW3));
[r1,c1]=size(VeloMapX);
VeloRadil=zeros(size(VeloMapX));
VeloTan=zeros(size(VeloMapX));


for i=1:1:r1
    for j=1:1:c1
       ang1=atan2((i-Centroid(2)),(j-Centroid(1)));
       %VeloTan(i,j)=sin(ang1-ang2)*sqrt(VeloMapX(i,j)^2+VeloMapY(i,j)^2);
       if VeloMapY(i,j)==0
           VeloRadil(i,j)=0;
       else
           ang2=atan2(VeloMapY(i,j),VeloMapX(i,j));
           VeloRadil(i,j)=cos(ang1-ang2)*sqrt(VeloMapX(i,j)^2+VeloMapY(i,j)^2);
       end
    end
end



figure

Img3=zeros(size(Img2));
h=imshow(255-Img3,[],'InitialMagnification',500);

%VeloRadil(BW2==0)=NaN;

hold on;
cmap=jet;
for i=1:1:length(Xp)
    if BW2(Yp(i),Xp(i))==1
        velo=VeloRadil(Yp(i),Xp(i));
        cid=floor((velo+1.5*CB)/(CB*3)*256);
        if cid>=256
            cid=256;
        end
        if cid<=0
            cid=1;
        end

        C=cmap(cid,:);
        q=quiver(Xp(i),Yp(i),VX(i)*pix_amp,VY(i)*pix_amp,'off','LineWidth',3,'Color',C,'MaxHeadSize',4);
    end
end

plot(Centroid(:,1),Centroid(:,2),'ko','MarkerSize',12);
%q=quiver(Xp,Yp,VX*1.6,VY*1.6,'off','LineWidth',2,'Color','k');

%q.AutoScaleFactor = 0.5;
% 
 %saveas(gcf,['PIV_DEMO_WT','7-9','.png'])



end


