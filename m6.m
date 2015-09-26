vidDevice = imaq.VideoDevice('winvideo', 1, 'YUY2_640x480', ...
'ROI', [1 1 640 480], ...
'ReturnedColorSpace', 'rgb');

hVideoIn = vision.VideoPlayer;
hVideoIn.Name = 'Original Video';
hVideoIn.Position = [30 100 640 480];

hVideoOut = vision.VideoPlayer;
hVideoOut.Name = 'Fingers Tracking Video';
hVideoOut.Position = [700 100 640 480];

while 1
    img = step(vidDevice);
    J = rgb2gray(img);
    background = imopen(J,strel('disk',15));
    i2 = J + background;
    i3 = imadjust(i2);
    level = 70/255;
    %level = graythresh(i3);
    max_area = 70000;
    min_area=60000;
    %level = graythresh(img);
    bw = im2bw(i3,level);
    %wb=imcomplement(bw);
    wb=bw;
    wb = bwareaopen(wb,max_area);   
    cc=bwconncomp(wb);
    graindata=regionprops(cc);
    area1 = [graindata.Area];
    if cc.NumObjects>1
        max_area= max(area1)-1000;
        wb=xor(bwareaopen(wb,min_area),bwareaopen(wb,max_area));
        cc=bwconncomp(wb);
        cc.NumObjects;
    end 
    graindata=regionprops(cc);
    area1 = [graindata.Area];
    step(hVideoIn, img);
    step(hVideoOut,wb);
end
release(hVideoOut);
release(hVideoIn);
