filePath='./';
filename='MAX_ctr.lif - Series0017.tif';
cadherin=imread([filePath,filename],1);
rasip=imread([filePath,filename],2);

reso=0.174;

[R1,N1]=size(cadherin);
RGB=uint8(zeros(R1,N1,3));
RGB(:,:,2)=cadherin;
RGB(:,:,1)=rasip;
% level = graythresh(cadherin);
% BW_m = im2bw(cadherin, level*5);
figure
img=imshow(RGB);

roi = images.roi.Freehand;
draw(roi)

polyX=roi.Position(:,1);
polyY=roi.Position(:,2);

[rowN,colN,~]=size(cadherin);
matbit=zeros(rowN,colN);


[X,Y] = meshgrid(1:1:colN,1:1:rowN);

BWS=inpolygon(X, Y, polyX, polyY);



%%
STATS = regionprops(BWS, 'Centroid','Area','BoundingBox');
BoundingBox=STATS.BoundingBox;
BWS_box=BWS(round(BoundingBox(2)):1:(round(BoundingBox(2))+BoundingBox(4)),round(BoundingBox(1)):1:(round(BoundingBox(1))+BoundingBox(3)));
cadherin_box=cadherin(round(BoundingBox(2)):1:(round(BoundingBox(2))+BoundingBox(4)),round(BoundingBox(1)):1:(round(BoundingBox(1))+BoundingBox(3)));
rasip_box=rasip(round(BoundingBox(2)):1:(round(BoundingBox(2))+BoundingBox(4)),round(BoundingBox(1)):1:(round(BoundingBox(1))+BoundingBox(3)));

level1 = graythresh(cadherin_box);
BW_cadherin_Box = im2bw(cadherin_box, level1*1);

level2 = graythresh(rasip_box);
BW_rasip_Box = im2bw(rasip_box, level2*1);

rasip_bw_in_box=BW_rasip_Box&BWS_box;
cadherin_bw_in_box=BW_cadherin_Box&BWS_box;

co_rasip_cadherin=rasip_bw_in_box&cadherin_bw_in_box;

figure
subplot(3,2,1);
imshow(cadherin_box*2);
subplot(3,2,2);
imshow(cadherin_bw_in_box);
subplot(3,2,3);
imshow(rasip_box);
subplot(3,2,4);
imshow(rasip_bw_in_box);
subplot(3,2,5);
imshow(co_rasip_cadherin);


size_cadherin=nnz(cadherin_bw_in_box);
size_rasip=nnz(rasip_bw_in_box);
size_co=nnz(co_rasip_cadherin);
size_area=nnz(BWS_box);
real_area=reso*reso*size_area;
index_overall=size_co*2/(size_cadherin+size_rasip);
index_rasip=size_co/size_rasip;
index_cadherin=size_co/size_cadherin;

output=[real_area,index_overall,index_rasip,index_cadherin];
