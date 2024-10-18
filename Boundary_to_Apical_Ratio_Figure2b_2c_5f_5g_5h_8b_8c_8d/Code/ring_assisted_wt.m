%%
excelname='./ring_cdh5_info.xlsx';
T = readtable(excelname,'Sheet','WT');


%%
folderName='./WT/20211111rasip1-scarlet-cdh5-TS/';
fileName='E4M3_t1.png';
PixelReso=0.170;
I = imread([folderName,fileName]);
img = imshow(I);
roi = drawfreehand;
draw(roi);
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
RMat=I(:,:,1);
GMat=I(:,:,2);



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

C = {folderName,fileName,P.Perimeter*PixelReso,P.Area*PixelReso*PixelReso,AveGJ,AveGA,SumRJ,SumRA};

[r1,c1]=size(T);
T(r1+1,:)=C;

%%

writetable(T,excelname,'Sheet','WT');

