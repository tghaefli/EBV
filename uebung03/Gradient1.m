clear 'all'
close 'all';

%read image
Image = imread('London.png');
%transform to double once and for all
Image = double(Image);

%plot the image
figure(1);
subplot(1,3,1);
imshow(Image, []);
title('Original');

%choose the filters %??????
Sobel = 1;
if Sobel == 1
    DX = [1];
    DY = [1];
else
    DX = [1];
    DY = [1];
end

%apply the DX and DY filter
ImageDx = imfilter(Image, DX);
ImageDy = imfilter(Image, DY);
%plot 
subplot(1,3,2);
imshow(ImageDx, []);
title('dI/dx');
subplot(1,3,3);
imshow(ImageDy, []);
title('dI/dy');




