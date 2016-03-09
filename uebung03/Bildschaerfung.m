clear 'all'
close 'all';

%read image
Image = imread('London.png');
%transform to double to once and for all
Image = double(Image);

%plot the image
figure(1);
subplot(1,2,1);
imshow(Image, []);
title('Original');

%define the filter ??????
Beta = 0.5;
Mask = [1];

%apply the filter
ImageEnh = imfilter(Image, Mask);

%plot it
subplot(1,2,2);
imshow(ImageEnh, [0 255]);%we explicitly choose the intervall because ImageEnc has values outside!!
title('Laplace');



