clear all;
close all;
clc;

%read image
Image = imread('London.png');

%plot the image
figure(1);
subplot(2,2,1);
imshow(Image);
title('Original');

%apply noise with Probability 7%
% Probability = 0.07;
% ImageNoise = imnoise(Image, 'salt & pepper', Probability);
% imwrite(ImageNoise, 'London_noise.png', 'png');
ImageNoise = imread('London_noise.png');

%plot 
subplot(2,2,2);
imshow(ImageNoise);
title('salt & pepper noise, 7%');

%apply a median filter
N = 9;
ImageMedian = medfilt2(ImageNoise, [N N]);
ImageMedian = ordfilt2(ImageNoise, round(N^2/2), ones(N,N)); 


%plot
subplot(2,2,3);
imshow(ImageMedian);
title('Median Filter');

%apply a low pass gaussian filter
GaussM = [1 2 1; 2 4 2; 1 2 1]/16;
ImageGauss = imfilter(ImageNoise, GaussM);
%plot
subplot(2,2,4);
imshow(ImageGauss, []);
title('Gauss Filter');

figure(2);hold on
plot(Image(200,:), 'bo-');
xlabel('x-Wert (Zeile 200)');
ylabel('Grauwert');
plot(ImageNoise(200,:), 'r-');
plot(ImageMedian(200,:), 'g-');
plot(ImageGauss(200,:), 'c-');
legend('Original', 'salt & pepper noise, 7%', 'Median Filter', 'Gauss Filter');