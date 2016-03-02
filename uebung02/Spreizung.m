clear 'all';
close 'all';
%read image
Image = imread('London_squeez.png');
 
%plot the image 
figure(1);subplot(2,2,1);
imshow(Image);
title('original image');

%plot histogram
subplot(2,2,2);
imhist(Image);
title('histogram');

%LUT for spreading gray values
LUT_Spread = uint8([0:255]);%??????????????????

%apply LUT
ImageSpread = intlut(Image, LUT_Spread);


%plot the image and corresponding histogram
subplot(2,2,3);
imshow(ImageSpread);
title('spread image');

subplot(2,2,4);
imhist(ImageSpread);
title('histogram');

