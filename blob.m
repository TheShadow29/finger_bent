function [b c] = blob(I,z)
    [xmax,ymax]=size(I);
     b = (1-z) + zeros(xmax,ymax);
     x1=0;x2=xmax;
     y1=0;y2=ymax;
    
    for i=1:xmax-1
       for j=1:ymax-1
           if I(i,j)==z && (I(i,j+1)==1-z || I(i,j-1)==1-z)
                b(i,j)=z;
           end
       end
    end
    flag=0;
    for j=1:ymax-1
        for i=xmax-1:-1:1
            if b(i,j)==z
                x1=j;
                flag=1;
                break
            end
        end
        if flag==1
            flag=0;
            break
        end
    end
        
    for j=ymax-1:-1:1
        for i=xmax-1:-1:1
            if b(i,j)==z
                x2=j;
                flag=1;
                break
            end
        end
        if flag==1
            flag=0;
            break
        end
    end
    for i=1:xmax-1
        for j=1:ymax-1
            if b(i,j)==z
                y1=i;
                flag=1;
                break
            end
        end
        if flag==1
            flag=0;
            break
        end
    end
    for i=xmax-1:-1:1
        for j=1:ymax-1
            if b(i,j)==z
                y2=i;
                flag=1;
                break
            end
        end
        if flag==1
            flag=0;
            break
        end
    end
    c = imcrop(b,[x1 y1 x2-x1 y2-y1]);
    
    imshow(b);
    imshow(c);
end