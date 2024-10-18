filePath='./';
RGB=imread([filePath,'tri','.png']);
RGB = imgaussfilt(RGB,1);

G=RGB(:,:,3);
R=RGB(:,:,1);

level = graythresh(G);
BWG = im2bw(G, level*1.6);
figure
imshow(BWG);


STATS = regionprops(BWG, 'Centroid','Area','PixelList');
Areas=cat(1,STATS.Area);

idx=find(Areas>80);
BWGC=zeros(size(BWG));
for i=1:1:length(idx)

    Apical_list=STATS(idx(i)).PixelList;
    pos=sub2ind(size(BWGC),Apical_list(:,2),Apical_list(:,1));
    BWGC(pos)=true;
end

figure
imshow(BWGC);




%%
level = graythresh(R);
BWR = im2bw(R, level*2);
figure
imshow(BWR);



STATS = regionprops(BWR, 'Centroid','Area','PixelList');
Areas=cat(1,STATS.Area);
idx=find(Areas>80);
BWRC=zeros(size(BWR));
for i=1:1:length(idx)

    Apical_list=STATS(idx(i)).PixelList;
    pos=sub2ind(size(BWR),Apical_list(:,2),Apical_list(:,1));
    BWRC(pos)=true;
end

figure
imshow(BWRC);

%%

T_RGB=uint8(zeros(size(RGB)))+255;

%
T_RGB(:,:,1)=255-BWGC*255;
T_RGB(:,:,3)=255-BWGC*255;
T_RGB(:,:,2)=255-BWRC*255;
T_RGB(:,:,3)=255-BWRC*255;

imshow(T_RGB);
