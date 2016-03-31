clear 'all';
close 'all';

%this is the image size
SizeXImage = 150;
SizeYImage = 150;
%this is the rectangle size
XRect = 2;
YRect = 30;
% use additional rectangle
unsimetrical_image = false;

%create image
Image = zeros(SizeYImage, SizeXImage);
%start values of rectangle
Sx = floor(SizeXImage/2-XRect/2);
Sy = floor(SizeYImage/2-YRect/2);
%set the rectangle
Image(Sy:Sy+YRect-1,Sx:Sx+XRect-1) = 1;
if(unsimetrical_image)
    Image(1:30,1:30) = 1;                   
end

%calculate DFT (keep size of image)
Image_FFT = abs(fft2(Image));%????????

%plot image
figure(1);
subplot(2,2,1);
imshow(Image, []);
TheTitle = sprintf('Rectangle of Size (%d x %d)', XRect, YRect);
title(char(TheTitle));

subplot(2,2,2);
%plot the DFT
imshow(Image_FFT,[]);%??????
title('Fourier Transform');

subplot(2,2,3);
%use fftshift to center the DFT


imshow(fftshift(Image_FFT),[0 log(XRect*YRect)]);%???????
title('log Fourier Transform (with fftshift)');

%choose the rowindex

SizeFFT = size(Image_FFT,2);
RowIndex = 1;
subplot(2,2,4);
plot(fftshift(Image_FFT(RowIndex,:)), 'bo');
TheTitle = sprintf('fft of row nr. %d. (with fftshift)', RowIndex);
axis([1 SizeFFT 0 XRect*YRect]);
title(char(TheTitle));



   
