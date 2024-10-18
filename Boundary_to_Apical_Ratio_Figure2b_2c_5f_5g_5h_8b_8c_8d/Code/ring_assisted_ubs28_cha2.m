%%
excelname='./ring_cdh5_info.xlsx';
T = readtable(excelname,'Sheet','heg1');


%%
folderName='./heg1/20230113heg1m552-cdh5-TS-myl9a-GFP/';
fileName='SUM_R3C4.lif - Series012.tif';
PixelReso=0.252;
I = imread([folderName,fileName],2);
img = imshow(I,[]);
roi = drawfreehand;

%%
polyX=roi.Position(:,1);
polyY=roi.Position(:,2);

[rowN,colN,~]=size(I);
matbit=zeros(rowN,colN);


[X,Y] = meshgrid(1:1:colN,1:1:rowN);

BW=inpolygon(X, Y, polyX, polyY);

%%

BWB = bwperim(BW,4);

%imshow(BW2)\

P = regionprops(BW,'perimeter','Area');
P.Perimeter;



SE = strel("disk",2);
BWE = imerode(BW,SE);

BWD = imdilate(BW,SE);



% figure
% 
BWJspace=(BWD)&(~BWE);
% imshow(BWI);
%%
GMat=I(:,:,1);
RMat=I(:,:,1);



AveGJ=mean(GMat(BWB));
%SumGJ=sum(GMat(BWB));
AveGA=mean(GMat(BWE));
% SumGA=sum(GMat(BWE));


SumRJ=sum(RMat(BWJspace));
SumRA=sum(RMat(BWE));

RGB=I;
RGB(:,:,3)=BWJspace*200;
figure
imshow(RGB);
%%

C = {folderName,fileName,P.Perimeter*PixelReso,P.Area*PixelReso*PixelReso,AveGJ,AveGA};

[r1,c1]=size(T);
T(r1+1,:)=C;

%%

writetable(T,excelname,'Sheet','heg1');

