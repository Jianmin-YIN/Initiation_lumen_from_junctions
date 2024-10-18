function [PredictPos,PredictVel,Credibility]=pivTrack(img1,img2,ProbePos,varargin)
%pivTrack could predict velocity and position of selected pixels in the next frame.

%img1 is the image at time t

%img2 is the image at time t+1

%size of img1 and size of img2 should be the same

%ProbePos should be in the form of [x1,y1;x2,y2], representing the group...
%of point in image you want to track.

%radius represents the size of subregion you want to compare between two...
%images, 50 is the default value

if nargin > 3
    radius = varargin{1};
else
    radius=50; % this parameter could be changed, it represents the size of subregion you want to compare between two images.
end
ittWidth = radius*2+1;
ittHeight = radius*2+1;
s2ntype = 2;
s2nl = 1;
sclt = 1;
outl = 100;
NfftWidth = 2*ittWidth;
NfftHeight = 2*ittHeight;
[row,col]=size(img1);
NumOfProbe=size(ProbePos,1);
PredictPos=[];
PredictVel=[];
Credibility=[];
for i=1:1:NumOfProbe
            px=ProbePos(i,1);
            py=ProbePos(i,2);
            px1=px;
            py1=py;
            if px<radius+1
                px1=radius+1;
            end
            if px>col-radius
                px1=col-radius;
            end
            if py<radius+1
                py1=radius+1;
            end
            if py>row-radius
                py1=row-radius;
            end
            X1=round(px1-radius);
            X2=round(px1+radius);
            Y1=round(py1-radius);
            Y2=round(py1+radius);
            subImg1 = img1(Y1:Y2,X1:X2);
            subImg2 = img2(Y1:Y2,X1:X2);
            
            c = cross_correlate_rect(subImg1,subImg2,NfftHeight,NfftWidth);
            [peak1,peak2,pixi,pixj] = find_displacement_rect(c,s2ntype);
            [peakVer,peakHor,s2n] = sub_pixel_velocity_rect(c,pixi,pixj,peak1,peak2,s2nl,sclt,ittWidth,ittHeight);
            vx = (ittHeight-peakHor)*sclt;
            vy = (ittWidth-peakVer)*sclt; 
            x=px+ittWidth-peakHor;
            y=py+ittWidth-peakVer;
            PredictPos(i,:)=[x,y];
            PredictVel(i,:)=[vx,vy];
            if s2n>outl
                Credibility(i)=s2n;
            else
                Credibility(i)=s2n;
            end
end


end

