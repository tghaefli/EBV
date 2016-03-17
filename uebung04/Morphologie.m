clear all;
close all;
clc;


%read image (is logical)
Image = imread('Morphologie.bmp');

%plot the image
figure(1);
subplot(2,2,1);
imshow(Image);
title('Original');

%define the structure element
%??????????????
StrucElem = eye(3);
StrucElem = ones(1,5);  % Add(dilataion) or remove(erosion) 2 Pixel in horizontal direction
StrucElem = ones(5,1);  % Add(dilataion) or remove(erosion) 2 Pixel in horizontal direction
%StrucElem = ones(3);   % Add(dilataion) or remove(erosion) 1 Pixel
%StrucElem = ones(5);   % Add(dilataion) or remove(erosion) 2 Pixel
%StrucElem = [1 1 1 ; 0 0 1 ; 0 0 1 ]  % Ref.-Punkt ist in der Mitte, jedoch nicht true

%plot it (we use imdilate to plot the structure element)
subplot(2,2,2);
Help = uint8(zeros(size(Image)));
Help(size(Image,1)/2, size(Image,2)/2) = 1;
Help = imdilate(Help, StrucElem);
imshow(Help, []);
title('Structure Element');

%do a dilation 
ImageDil = imdilate(Image, StrucElem);
ImageDil = 255*ImageDil;
ImageDil(Image ~= 0) = 128;

%plot 
subplot(2,2,3);
imshow(ImageDil, []);
title('Dilation');

%do an erosion 
ImageErode = imerode(Image, StrucElem);
Help = 255*ImageErode;
Help(Image ~= ImageErode) = 128;

%plot
subplot(2,2,4);
imshow(Help, []);
title('Erosion - white:leftover / grey:removed');
