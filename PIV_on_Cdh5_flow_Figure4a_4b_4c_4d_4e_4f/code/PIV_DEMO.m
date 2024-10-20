image1        =   imread('./F2(flux)_crop-1_t029_c001.tif',1);
image2        =   imread('./F2(flux)_crop-1_t030_c001.tif',1);
img1          =   image1;
img2          =   image2;
 %% select pixels  and track
level = graythresh(img1);
BW = imbinarize(img1,level*1.5);
BW2 = imfill( BW ,'holes');



STATS = regionprops(BW2, 'Centroid','Area','PixelList');
Areas=cat(1,STATS.Area);
[~,index]=max(Areas);
Apical_list=STATS(index).PixelList;
Centroid=STATS(index).Centroid;

BW3=false(size(BW2));

idx=sub2ind(size(BW2),Apical_list(:,2),Apical_list(:,1));
BW3(idx)=true;


ProbeNum=20;

probeX          =   linspace(10,100,ProbeNum);
probeY          =   linspace(10,90,ProbeNum);
[X,Y]           =   meshgrid(probeX,probeY);
ProbePos        =   [reshape(round(X),[],1),reshape(round(Y),[],1)];

ProbePos2=[];
[r1,c1]=size(ProbePos);




idx_ori=sub2ind(size(BW3),ProbePos (:,2),ProbePos (:,1));
idx_sle=idx_ori(BW3(idx_ori)==1);

[col1,col2] = ind2sub(size(BW3),idx_sle);
ProbePos3=[col2,col1];


[PredictPos,PredictVel,Credibility]=pivTrack(img1,img2,ProbePos3,7); % PredictPos is in the form of [x1,y1;x2,y2];PredictVel is in the form of [vx1,vy1;vx2,vy2];In Credibility1 means reliable, 0 is not


    
    %%
    X   =   ProbePos3(:,1);
    Y   =   ProbePos3(:,2);
    VX  =   PredictVel(:,1);
    VY  =   PredictVel(:,2);
    figure,imshow(img1,[]);
    hold on;
    quiver(X,Y,VX,VY,'LineWidth',1.5,'Color','r');
    pause(0.2)
    hold off;
    set(gcf, 'Position',  [100, 100, 800, 800])
    saveas(gcf,['test_result','.png'])