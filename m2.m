cam = webcam(1);
figure
figure
while 1
    img = snapshot(cam);
    imshow(img);
    J = rgb2gray(img);
    background = imopen(J,strel('disk',15));
    i2 = J + background;
    i3 = imadjust(i2);
    level = 170/255;
    %level = graythresh(img);
    bw = im2bw(i3,level);
    wb=imcomplement(bw);
    wb = bwareaopen(wb, 90000);
    imshow(wb);
    cc=bwconncomp(wb);
    graindata = regionprops(cc);
    graindata.Area;
end
