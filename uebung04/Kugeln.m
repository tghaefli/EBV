clear 'all'
close 'all';

Cmap = colormap(jet);
Cmap(1,:) = 0;

%read image
Image = imread('kugeln.png');

%plot the image
figure(1);
subplot(2,2,1);
imshow(Image);
title('Original');

%apply threshold opertion
ImageThr = Image < 147;

%plot 
subplot(2,2,2);
imshow(ImageThr, [0 1]);
title('Threshold');

%define the structure element ????
StrucElem = 1;

%do a closure ????
ImageClose = ImageThr;

%plot 
subplot(2,2,3);
imshow(ImageClose);
title('Closure');

StrucElem = 1; %?????
%do erosions ??????
ImageErode = ImageClose;
%plot 
subplot(2,2,4);
imshow(ImageErode);
title('Erosion');



