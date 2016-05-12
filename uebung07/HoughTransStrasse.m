%
% Hough transformation
%
clear all;  close all;  clc;

%read image
Image = imread('Strasse.png');
%plot it
figure(1);
subplot(3,1,1);
imshow(Image);
title('original image');

% Detect the edges, the result is a binary image
EdgeCanny = edge(Image, 'canny', [0 0.1], 1);
%plot it
subplot(3,1,2);
imshow(EdgeCanny, []);
title('Canny edge detection');

% Hough transformation, calculate the accumulator Hough
[Hough, Theta, Rho] = hough(EdgeCanny, 'RhoResolution', 1);
figure(2)
imshow(mat2gray(Hough));
colormap('hot');
xlabel('Theta');
ylabel('Rho')
title('Hough Accumulator');


 