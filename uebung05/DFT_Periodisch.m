clear 'all';
close 'all';

%read image
Image = imread('Kristall.png');

%shortcut
ImgS = size(Image);

%create a shifted image
ImageShift = fftshift(Image);

%do fft (keep the same size, otherwise we pad zeros and do not get the same
%results for original and shifted image)
Image_FFT = fft2(Image);

%plot the whole stuff
figure(1);
subplot(1,2,1);
imshow(Image);
title('original image');
subplot(1,2,2);
imshow(log(abs(fftshift(Image_FFT))),[]);
title('DFT');

%fft of shifted image
Image_FFT_Shift = fft2(ImageShift);

figure(2);
subplot(1,2,1);
imshow(ImageShift);
title('original image (shifted)');
subplot(1,2,2);
imshow(log(abs(fftshift(Image_FFT_Shift))),[]);
title('DFT');


%apply Hanning window ??????
%Hann = ;
Image_Hann = double(Image);
Image_FFT_Ham = fft2(Image_Hann);

figure(3)
subplot(1,2,1);
imshow(Image_Hann,[]);
title('original image with hann window');
subplot(1,2,2);
imshow(log(abs(fftshift(Image_FFT_Ham))),[]);
title('DFT after application of hann window');

