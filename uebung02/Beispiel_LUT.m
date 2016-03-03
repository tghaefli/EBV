clear 'all';
close 'all';

%read image
Image = imread('London.png');
 
%plot the image 
figure(1);subplot(1,2,1);
imshow(Image);
title('original image');

%plot histogram
subplot(1,2,2);
imhist(Image);
title('histogram');

%LUT for inverse image
LUT_Inv = uint8(255:-1:0);

%apply LUT
ImageInv = intlut(Image, LUT_Inv);

%plot the image 
figure(2);subplot(1,2,1);
imshow(ImageInv);
title('inverse image');

%plot histogram
subplot(1,2,2);
imhist(ImageInv);
title('histogram');


%create a LUT which enhances dark parts in image and show results
LUT_Enh = uint8([0:2:254,255*ones(1,128)]);
LUT_Enh = uint8(0:2:2*255);


ImageEnh = intlut(Image, LUT_Enh);

%plot the image 
figure(3);subplot(1,2,1);
imshow(ImageEnh);
title('enhanced image');

%plot histogram
subplot(1,2,2);
imhist(ImageEnh);
title('histogram');