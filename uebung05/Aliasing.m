clear all;  close all;  clc;

% Parameter eingeben
DownSampling = 5;   % Downsampling-Faktor
N = 2*DownSampling;
% read image
Image = imread('kreise.png');

% plot it
figure(1);
imshow(Image);
title('Original Image');

% Downsampling w/o and with Antialiasing-Filter
figure(2)
%do sampling
ImageAlias = Image(1:DownSampling:end, 1:DownSampling:end);   
%plot it (may scale up)
%imshow(ImageAlias, 'InitialMagnification', 100);
imshow(ImageAlias);
title('Moiree pattern due to Aliasing');
xlabel(['downsampling with N=' num2str(DownSampling)]);

%apply anti aliasing filter
Mask = fspecial('average', N);%???????
Mask = fspecial('gaussian', N, N);%???????

%Mask = 1/16 * [1 2 1 ;
%               2 4 2 ;
%               1 2 1];

%first apply filter
ImageDecimate = imfilter(Image,Mask);
%do sampling
ImageDecimate = ImageDecimate(1:DownSampling:end, 1:DownSampling:end);
%and plot
figure(3)
%imshow(ImageDecimate, 'InitialMagnification', 100);
imshow(ImageDecimate);
title('no Moiree pattern due to anti Aliasing filter');
xlabel(['downsampling with N=' num2str(DownSampling)]);

