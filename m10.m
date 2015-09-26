vidDevice = imaq.VideoDevice('winvideo', 1, 'YUY2_640x480', ...
'ROI', [1 1 640 480], ...
'ReturnedColorSpace', 'rgb');

hVideoIn = vision.VideoPlayer;
hVideoIn.Name = 'Original Video';
hVideoIn.Position = [30 30 640 480];

hVideoOut = vision.VideoPlayer;
hVideoOut.Name = 'Fingers Tracking Video';
hVideoOut.Position = [700 100 640 480];

%vectors
vect = zeros(2,10);
len_vec = zeros(1,10);
max_len_vec = len_vec;

mt = zeros(1,5);
%frames
frm=0;
while 1
    img = step(vidDevice);
    [m, n]=size(img);
    J = rgb2gray(img);
    background = imopen(J,strel('disk',15));
    i2 = J + background;
    i3 = imadjust(i2);
    level = 100/255;
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
    if ~isempty(stats)

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
  
    
        
    pts = zeros(2,6);
    pts(1:2,1)=[cx,cy];
    pts2 = zeros(2,6);
    pts(1:2,1)=[cx,cy];
    [m ,n]=size(final);
    ind = 2;
    flag =0;
    final2 = final;
    imshow(final2);
    for idx=1:c1.NumObjects
        gr = false(size(wb));
        gr(c1.PixelIdxList{idx})= true;
        for i=1:m-1
            for j=1:n-1
                if gr(i,j)==1
                    pts(1:2,ind)=[i j];
                    viscircles([j i],2);
                    ind=ind+1;
                    flag=1;
                    break
                end
            end
            if flag==1
                flag=0;
                break
            end
        end
    end
    
    
    
    viscircles([cx cy],10);
    for ii=2:c1.NumObjects+1
        line([cx,pts(2,ii)],[cy,pts(1,ii)]);
    end
    
    %if c1.NumObjects==5
        for ii=1:5
            vect(1:2,ii)=[cx - pts(2,ii+1), cy - pts(1,ii+1)];
            len_vec(ii) = sqrt(sum(vect(:,ii).^2));
        end
    %end
    if c1.NumObjects==5
        for ii=1:c1.NumObjects
            if max_len_vec(ii)<len_vec(ii)
                max_len_vec(ii)=len_vec(ii);
            end
            if len_vec(ii)<.75*max_len_vec(ii)
                mt(ii)=0;
            else
                mt(ii)=1;
            end
            
        end
    end

        
else
    %mt=zeros(1,5);
    %step(hVideoOut,out);
    end
    %step(hVideoOut,wb);
    mt      
end
release(hVideoOut);
release(hVideoIn);