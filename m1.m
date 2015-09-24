I = imread('4_fingers.jpg');
J = rgb2gray(I);

background = imopen(J,strel('disk',15));
I2 = J + background;

I3 = imadjust(I2);

%level = graythresh(I3);
level = 80/255;
bw = im2bw(I3,level);
wb=imcomplement(bw);
wb = bwareaopen(wb, 90000);

%figure;imshow(bw);


figure;imshow(wb);
cc=bwconncomp(wb);
graindata = regionprops(cc);
graindata.Area
