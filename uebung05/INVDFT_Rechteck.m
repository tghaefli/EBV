clear 'all';
close 'all';

%this is the image size
SizeXImage = 150;
SizeYImage = 150;

%this is the rectangle size
XRect = 10;
YRect = 30;


%create image
Image = zeros(SizeYImage, SizeXImage);
%start values of rectangle
Sx = floor(SizeXImage/2-XRect/2);
Sy = floor(SizeYImage/2-YRect/2);
%set the rectangle
Image(Sy:Sy+YRect-1,Sx:Sx+XRect-1) = 1;

%we want to choose power of 2 and have image symmetric
SizeFFT = max(2^ceil(log(SizeXImage)/log(2)), 2^ceil(log(SizeYImage)/log(2)));
%calculate DFT (keep size of image)
%Image_FFT = fft2(Image);
Image_FFT = fft2(Image, SizeFFT, SizeFFT);

%now we mask out all frequencies above the first zero position 
Mask = ones(SizeFFT);%???????

%plot image
figure(1)
subplot(2,2,1);
imshow(Image, []);
TheTitle = sprintf('Rectangle of Size (%d x %d)', XRect, YRect);
title(char(TheTitle));

subplot(2,2,2);
%use fftshift to center the DFT
imshow((abs(fftshift(Image_FFT))),[]);
title('Fourier Transform');

%apply mask
Image_FFT_Mask = Image_FFT.*fftshift(Mask);

subplot(2,2,3);
%use fftshift to center the DFT
imshow((abs(fftshift(Image_FFT_Mask))),[]);
title('Masked Fourier Transform');

%caluclate the inverse fft an plot
Inv_FFT = abs(ifft2(Image_FFT_Mask));

subplot(2,2,4);
%use fftshift to center the DFT
imshow(Inv_FFT(1:SizeYImage, 1:SizeXImage),[]);
title('Inverse Fourier Transform');

%also plot one single row for better comparison
figure(2); hold on
plot(Inv_FFT(SizeYImage/2, 1:SizeXImage),'bo-');
plot(Image(SizeYImage/2,:),'r*-');
title('comparision of inverse fft and original image for single row');
legend('inverse fft', 'original image');
