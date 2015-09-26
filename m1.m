I = imread('5_fingers.jpg');
J = rgb2gray(I);

background = imopen(J,strel('disk',15));
I2 = J + background;

I3 = imadjust(I2);

level=70/255;
max_area = 10000;
bw = im2bw(I3,level);
wb= imcomplement(bw);
wb=bwareaopen(wb,max_area);
%figure;imshow(bw);
cc=bwconncomp(wb);
graindata = regionprops(cc);
area1=[graindata.Area];
area1
if cc.NumObjects>1
    max_area=max(area1)-1000;
    wb=bwareaopen(wb,max_area);
    cc=bwconncomp(wb);
    %cc.NumObjects
end 
graindata = regionprops(cc);
area1=[graindata.Area];
centroid = graindata.Centroid
imshow(wb);

cc.NumObjects;
