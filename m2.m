cam = webcam(1);
while 1
    img = snapshot(cam);
    %clearimshow(img);
    J = rgb2gray(img);
    background = imopen(J,strel('disk',15));
    i2 = J + background;
    i3 = imadjust(i2);
    level = 200/255;
    %level = graythresh(img);
    bw = im2bw(i3,level);
    %wb=imcomplement(bw);
    wb=bw;
    wb = bwareaopen(wb, 90000);
    imshow(wb);
    cc=bwconncomp(wb);
    graindata = regionprops(cc);
    graindata.Area;
end
