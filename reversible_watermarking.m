image=imread("penguin.jpg"); %importing the cover image;
figure, imshow(image);       
img=rgb2gray(image);         %converting the image to grayscale;
img1=img;
figure, imshow(img);         %didplaying the grayscale image
figure, imhist(img);         %displaying the histogram of the grayscal image;
[row,col]=size(img);
a=imhist(img);
peak_value=0;
%finding the peak point of the histogram;
for i=1:255
    if a(i) > peak_value
        peak_value=a(i);         %storing the hightest value of the histogram;
        peak_point=i;   %storing the position of hightest value of the histogram;
    end
end
 %finding the rightmost minimum point of the histogram;
mn=peak_value;
for i=peak_point:255
    if a(i) <= mn
        mn=a(i);
        posright=i; %storing the position of the rightmost minimum point
    end
end

%leftmn=peak_value;
%finding the leftmost minimum point
%for i=2:peak_point
%   if a(i)<=leftmn
%        leftmn=a(i);
%        posleft=i;  %storing the position of leftmost minimum point in pos
%    end
%end
%
pos_peak_point=peak_point; % peak point
pos_for_shifting_to_right_min=posright-2;%
overhead=mn;  %right min
for i=1:row
    for j=1:col
        if img(i,j)>=pos_peak_point && img(i,j)<=pos_for_shifting_to_right_min
            img(i,j)=img(i,j)+1;
        end
    end
end % intensity increase by 1 from peak point to rightmost minimum point

image_for_watermark=imread("ninja.jpg");
bw_watermark=imbinarize(image_for_watermark,0.4); % 
b=(uint8(sqrt(peak_value))-1); % embed capacity 
square_matrix=imresize(bw_watermark,[b,b]);
peak_point=peak_point-1; % peak point posiotion
rows=1;
cols=1;
flag=0;
for i=1:row
    if flag==1
        break;
    end
    
    for j=1:col
        if flag==1
            break;
        end
        
        if img(i,j) == peak_point
            if square_matrix(rows,cols)==1
                img(i,j)=img(i,j)+1;
                cols=cols+1;
            else
                img(i,j)=img(i,j);
                cols=cols+1;
            end
            if cols>b        % if column is gretaer than b then change the row
                rows=rows+1;
                cols=1;
            end
            if rows>b          % if row is greater than b then embed is completed
                flag=1;
                break;
            end
            
        end
    end
end
figure, imshow(img);
figure, imhist(img);
[peaksnr, snr]  =psnr(img,img1);
fprintf('\n the peak-SNR value is %0.4f',peaksnr);
%de water mark
flag=0;
r=1;
c=1;
result = zeros(b,b);
for i=1:row
    if flag==1
        break;
    end
    
    for j=1:col
        if flag==1
            break;
        end
        
        if img(i,j)== peak_point
            result(r,c)=0;
            c=c+1;
        end
        if img(i,j)==(peak_point+1)
            result(r,c)=1;
            c=c+1;
        end
        if(c>b)
            r=r+1;
            c=1;
        end
        if(r>b)
            flag=1;
            break;
        end
    end
end

%retrieve histogram
for i=1:row
    for j=1:col
        if img(i,j)==peak_point+1
            img(i,j)=img(i,j)-1;
        end
    end
end

for i=1:row
    for j=1:col
        if img(i,j)>=(peak_point+2)&&img(i,j)<=pos_for_shifting_to_right_min+1
            img(i,j)=img(i,j)-1;
        end
    end
end
figure, imshow(img);
figure, imhist(img);
