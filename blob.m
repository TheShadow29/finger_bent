function [b c] = blob(I,z)
    [m,n]=size(I);
     b = (1-z) + zeros(m,n);
     
    for i=1:m-1
       for j=2:n-1
           if I(i,j)==z && (I(i,j+1)==1-z || I(i,j-1)==1-z)
                b(i,j)=z;
           end
       end
    end
    imshow(b);
    D = [0 0 0 0 0;0 0 1 0 0];
    index=1;
    for i=1:m-1
       for j=1:n-1
           if I(i,j)==z
               if isequal(I(i-1:i,j-2:j+2),D)
                   c(1:2,index)=[i j];
                   viscircles([j i],5);
                   index=index+1;                   
               end
           end
       end
    end
    
%     for i=1:m-1
%         for j=1:n-1
%             if b(i,j)==z
%                 l = b(i-1,j-5:j+5);
%                 k = b(i,j-5:j+5);
%                 guess=1;
%                 for ii=1:10
%                     if l(ii)==z || k(ii)==z
%                         guess=0;
%                         break
%                     end
%                 end
%                 if guess==1
%                     c(1:2,index)=[i,j];
%                     index=index+1;
%                 end
%             end
%         end
%     end
%     c = imregionalmax(b,4);
%     imshow(b);
%     for i=1:m-1
%         for j=1:n-1
%             if c(i,j)==1
%                 viscircles([j i],5);
%             end
%         end
%     end
    
    %viscircles(c, r,'Color','b');
    
    %
        
%     flag=0;
%     for j=1:ymax-1
%         for i=xmax-1:-1:1
%             if b(i,j)==z
%                 x1=j;
%                 flag=1;
%                 break
%             end
%         end
%         if flag==1
%             flag=0;
%             break
%         end
%     end
%         
%     for j=ymax-1:-1:1
%         for i=xmax-1:-1:1
%             if b(i,j)==z
%                 x2=j;
%                 flag=1;
%                 break
%             end
%         end
%         if flag==1
%             flag=0;
%             break
%         end
%     end
%     for i=1:xmax-1
%         for j=1:ymax-1
%             if b(i,j)==z
%                 y1=i;
%                 flag=1;
%                 break
%             end
%         end
%         if flag==1
%             flag=0;
%             break
%         end
%     end
%     for i=xmax-1:-1:1
%         for j=1:ymax-1
%             if b(i,j)==z
%                 y2=i;
%                 flag=1;
%                 break
%             end
%         end
%         if flag==1
%             flag=0;
%             break
%         end
%     end
%     c = imcrop(b,[x1 y1 x2-x1 y2-y1]);
%     
    %imshow(b);
    %imshow(c);
end