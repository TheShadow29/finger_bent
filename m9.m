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
    [m n]=size(final);
    
    c1 = bwconncomp(final);
    c1.NumObjects;
    g1 = regionprops(c1);
    are = [g1.Area]
    are_sorted = sort(are);
    mt = zeros(1,5);
    if length(are_sorted)==5
        mt = ones(1,5);
    end
    if isempty(are_sorted)
        mt=zeros(1,5);
    end
    
    pts = zeros(2,6);
    pts(1:2,1)=[cx,cy];
    
    ind = 2;
    flag =0;
    imshow(final);hold on;
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
    %imshow(final);
else
    imshow(out);
    end

cc.NumObjects;
