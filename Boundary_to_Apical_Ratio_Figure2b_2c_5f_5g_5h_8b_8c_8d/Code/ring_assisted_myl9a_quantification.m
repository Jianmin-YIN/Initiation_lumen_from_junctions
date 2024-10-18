%%
excelname='./ring_myl9a_info.xlsx';
T = readtable(excelname,'Sheet','ccm1');


%%
folderName='./ubs28/';
fileName='mut_B1_P1_t98.png';
PixelReso=0.286;
I = imread([folderName,fileName]);

RMat=I(:,:,1);
GMat=I(:,:,2);

img = imshow(I);
roi = drawfreehand;

polyX=roi.Position(:,1);
polyY=roi.Position(:,2);

[rowN,colN,~]=size(I);
matbit=zeros(rowN,colN);


[X,Y] = meshgrid(1:1:colN,1:1:rowN);

BW=inpolygon(X, Y, polyX, polyY);

AveOut=mean(RMat(BW));

%%
img = imshow(I);
roi = drawfreehand;


polyX=roi.Position(:,1);
polyY=roi.Position(:,2);

[rowN,colN,~]=size(I);
matbit=zeros(rowN,colN);


[X,Y] = meshgrid(1:1:colN,1:1:rowN);

BW=inpolygon(X, Y, polyX, polyY);

BWB = bwperim(BW,4);

%imshow(BW2)\

P = regionprops(BW,'perimeter','Area');
P.Perimeter;



SE = strel("disk",3);
BWE = imerode(BW,SE);

BWD = imdilate(BW,SE);



% figure
% 
BWJspace=(BWD)&(~BWE);
% imshow(BWI);
%%




AveGJ=mean(GMat(BWB));
%SumGJ=sum(GMat(BWB));
AveGA=mean(GMat(BWE));
% SumGA=sum(GMat(BWE));


AveRJ=mean(RMat(BWB));
AveRA=mean(RMat(BWE));

RGB=I;
RGB(:,:,3)=BWJspace*200;
figure
imshow(RGB);
%%

C = {folderName,fileName,P.Perimeter*PixelReso,P.Area*PixelReso*PixelReso,AveGJ,AveGA,AveRJ,AveRA,AveOut};

[r1,c1]=size(T);
T(r1+1,:)=C;

%%

writetable(T,excelname,'Sheet','ubs28');

