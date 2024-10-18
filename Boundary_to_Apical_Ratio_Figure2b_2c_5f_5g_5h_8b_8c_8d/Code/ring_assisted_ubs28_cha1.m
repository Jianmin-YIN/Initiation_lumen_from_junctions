%%
excelname='./ring_cdh5_info.xlsx';
T = readtable(excelname,'Sheet','ubs28');


%%
folderName='./ubs28/20220410ubs28-hom-cdh5-TS-Highspeed/';
fileName='Pos003_S001_t31.png';
PixelReso=0.252;
I = imread([folderName,fileName]);
img = imshow(I);
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

GMat=I;



AveGJ=mean(GMat(BWB));
%SumGJ=sum(GMat(BWB));
AveGA=mean(GMat(BWE));
% SumGA=sum(GMat(BWE));



RGB=I;
RGB(:,:,3)=BWJspace*200;
figure
imshow(RGB);
%%

C = {folderName,fileName,P.Perimeter*PixelReso,P.Area*PixelReso*PixelReso,AveGJ,AveGA};

[r1,c1]=size(T);
T(r1+1,:)=C;

%%

writetable(T,excelname,'Sheet','ubs28');

