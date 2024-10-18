%%
excelname='./ZO1_ring_info.xlsx';
T = readtable(excelname,'Sheet','ubs8');


%%
folderName='./ubs8/';
fileName='MAX_ubs8-F15.lif - Series006.tif';
PixelReso=0.286;

RMat=imread([folderName,fileName],2);
GMat=imread([folderName,fileName],1);





%%
img = imshow(GMat,[]);
roi = drawfreehand;


polyX=roi.Position(:,1);
polyY=roi.Position(:,2);

[rowN,colN]=size(GMat);
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
figure
imshow(RMat,[]);
hold on
imshow(BWJspace);
%%




AveGJ=mean(GMat(BWB));
%SumGJ=sum(GMat(BWB));
AveGA=mean(GMat(BWE));
% SumGA=sum(GMat(BWE));


AveRJ=mean(RMat(BWB));
AveRA=mean(RMat(BWE));


%%

C = {folderName,fileName,P.Perimeter*PixelReso,P.Area*PixelReso*PixelReso,AveGJ,AveGA,AveRJ,AveRA};

[r1,c1]=size(T);
T(r1+1,:)=C;

%%

writetable(T,excelname,'Sheet','ubs8');

