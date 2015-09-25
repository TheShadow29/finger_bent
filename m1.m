I = imread('3_fingers.jpg');
J = rgb2gray(I);

background = imopen(J,strel('disk',15));
I2 = J + background;

I3 = imadjust(I2);

level=70/255;
max_area = 50000;
bw = im2bw(I3,level);
wb= imcomplement(bw);
wb=bwareaopen(wb,max_area);
%figure;imshow(bw);
cc=bwconncomp(wb);
graindata = regionprops(cc);
area1 = graindata.Area;
if cc.NumObjects>1
    max_area=max(area1)-10000;
    wb=bwareaopen(wb,max_area);
    cc=bwconncomp(wb);
    %cc.NumObjects
end 
imshow(wb);
cc.NumObjects
