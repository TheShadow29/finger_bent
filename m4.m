cam = videoinput('winvideo',1);
h = figure('Position', [200, 200, 250, 250]);
g = figure('Position', [500, 500, 250, 250]);

while 1
    img = getsnapshot(cam);
    %figure(h);
    set(0, 'currentfigure', h);
    imshow(img);
    J = rgb2gray(img);
    background = imopen(J,strel('disk',15));
    i2 = J + background;
    i3 = imadjust(i2);
    level = 200/255;
    max_area = 50000;
    %level = graythresh(img);
    bw = im2bw(i3,level);
    %wb=imcomplement(bw);
    wb=bw;
    wb = bwareaopen(wb, 90000);   
    cc=bwconncomp(wb);
    graindata = regionprops(cc);
    graindata.Area;
    %figure(g);
    set(0, 'currentfigure', g);
    area1 = graindata.Area;
    if cc.NumObjects>1
        max_area=max(area1)-10000;
        wb=bwareaopen(wb,max_area);
        cc=bwconncomp(wb);
        cc.NumObjects
    end 
    imshow(wb);

end
