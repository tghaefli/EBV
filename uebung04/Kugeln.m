clear all
close all;
clc;


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



diam = 4;
%define the structure element ????
StrucElem = strel('disk',diam);

%do a closure ????
ImageClose = imclose(ImageThr, StrucElem);
%ImageClose = ImageThr;

%plot 
subplot(2,2,3);
imshow(ImageClose);
title('Closure');


StrucElem = strel('disk',15);
%do erosions ??????
ImageErode = imerode(ImageClose, StrucElem);
%ImageErode = ImageThr;
%plot 
subplot(2,2,4);
imshow(ImageErode);
title('Erosion');



