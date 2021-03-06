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
    [m n]=size(img);
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
    step(hVideoIn,img);
    while cc.NumObjects>1
        max_area= max(area1)-1000;
        wb=xor(bwareaopen(wb,min_area),bwareaopen(wb,max_area));
        cc=bwconncomp(wb);
        cc.NumObjects;
    end 
    wb=imcomplement(wb);
    cc=bwconncomp(wb);
    graindata=regionprops(cc);
    area1 = [graindata.Area];
    cent = [graindata.Centroid];
    out = wb;
    stats=regionprops(out,'Centroid');
    if length(stats)

    cx=cent(1);
    cy=cent(2);

    %find the nearest countour point
    boundary=bwboundaries(out);
    minDist=2*640*640;
    mx=cx;
    my=cy;
    bImg=uint8(zeros(480,640));

    for i=1:length(boundary)
        cell=boundary{i,1};
        for j=1:length(cell)
            y=cell(j,1);
            x=cell(j,2);

            sqrDist=(cx-x)*(cx-x)+(cy-y)*(cy-y);
            bImg(x,y)=255;

            if(sqrDist<minDist)
                minDist=sqrDist;
                mx=x;
                my=y;
            end
        end
    end
    
    sed=strel('disk',round(sqrt(minDist)/2));
    final=imerode(out,sed);
    final=imdilate(final,sed);
    final=out-final;
    
    final=bwareaopen(final,200);
	final=imerode(final,strel('disk',5));
    final=bwareaopen(final,400);
    
    [L,num]=bwlabel(final,8);
    final=imclearborder(final,8);
  
    
    c1 = bwconncomp(final);
    c1.NumObjects;
    g1 = regionprops(c1);
    are = [g1.Area];
    are_sorted = sort(are);
    mt = zeros(1,5);
    if length(are_sorted)==5
        mt = ones(1,5);
    end
    if isempty(are_sorted)
        mt=zeros(1,5);
    end
    
    
    step(hVideoOut,final);
    
else
    step(hVideoOut,out);
    end
                
end
release(hVideoOut);
release(hVideoIn);