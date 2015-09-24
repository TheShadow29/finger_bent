I = imread('4_fingers.jpg');
J = rgb2gray(I);

background = imopen(J,strel('disk',15));
I2 = J + background;

I3 = imadjust(I2);

thresh = multithresh(I,2);
bw = imquantize(I3,thresh);
wb= imcomplement(bw);
wb=bwareaopen(wb,90000);
%figure;imshow(bw);


figure;imshow(wb);
cc=bwconncomp(wb);
graindata = regionprops(cc);
graindata.Area;
