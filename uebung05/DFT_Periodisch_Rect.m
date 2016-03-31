clear all;  close all;  clc;

%size of image
ImgS = [256 256];
%period in x-direction
StepX = 9;
%period in y-direction
StepY = 11;

%create images
ImageX = zeros(ImgS);
ImageY = zeros(ImgS);
%lines in x-direction with period StepY
ImageY(1:StepY:end, :) = 1;
%lines in y-direction with period StepX
ImageX(:, 1:StepX:end) = 1;

%multiply x-image and y-image 
ImageXY= ImageX.*ImageY;%???????
%ImageXY = ImageXY.*(hann(256)*hann(256)');  % not working

%plot everything
figure(1);
subplot(2,3,1);
imshow(ImageX, []);

subplot(2,3,2);
imshow(ImageY, []);

subplot(2,3,3);
%imshow(ImageXY, []);
imshow(fftshift(ImageXY), []);    % aliasing


%calculate and plot DFTs; the product of x-image and y-image will have 
%a DVF equal to the convolution of the respective x- and y-image DFTs
Image_FFTX = fft2(ImageX);
subplot(2,3,4);
imshow((abs(fftshift(Image_FFTX))), []);

Image_FFTY = fft2(ImageY);
subplot(2,3,5);
imshow((abs(fftshift(Image_FFTY))), []);


ImageXY_FFT = fft2(ImageXY);
subplot(2,3,6);
imshow((abs(fftshift(ImageXY_FFT))), []);







