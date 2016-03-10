clear all;
close all;
clc;


%read image
Image = imread('London.png');
%transform to double once and for all
Image = double(Image);

%plot the image
figure(1);
subplot(2,2,1);
imshow(Image, []);
title('Original');

%choose the filters
Sobel = 1;
if Sobel == 1
    DX = conv2([1 2 1]', [-1 0 1]);
    DY = conv2([-1 0 1]', [1 2 1]);
else % Prewitt
    DX = conv2([1 1 1]', [-1 0 1]);
    DY = conv2([-1 0 1]', [1 1 1]);
end

%apply the DX and DY filter
ImageDx = imfilter(Image, DX);
ImageDy = imfilter(Image, DY);
%plot 
subplot(2,2,3);
imshow(ImageDx, []);
title('dI/dx');
subplot(2,2,4);
imshow(ImageDy, []);
title('dI/dy');

subplot(2,2,2);
ImageDxy = sqrt(ImageDx.^2 + ImageDy.^2);
imshow(ImageDxy, [0 255]);
title('dI/dr');