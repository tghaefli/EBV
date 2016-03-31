clear 'all';
close 'all';

SizeFFT = 256;

Image = imread('Moire.png');

%plot original image
figure(1)
subplot(2,2,1);
imshow(Image);
title('original image');
    
%shortcut
ImgS = size(Image);
%do fft calculation
Image_FFT = fft2(Image, SizeFFT, SizeFFT);
%shortcut for maximum
MaxVal = Image_FFT(1);

%use imtool to find the positions of the frequencies
%%imtool(log(abs(fftshift(Image_FFT))),[0 log(sum(MaxVal))]);

NotchPos = [107 102;
            095 144;
            117 171;
            154 160;
            185 141;
            156 116;
            141 087;];%???? add new points in additional lines (row-, col-value!!) ??????????????

%apply the filter 
Filter  = NotchFilter( size(Image_FFT), NotchPos, 6*ones(1,size(NotchPos,1)) );

%plot the fft
subplot(2,2,2);
imshow(log(abs(fftshift(Image_FFT))),[]);
title('DFT');

%plot the fft times the filter
subplot(2,2,3);
imshow(log(abs(fftshift(Image_FFT).*Filter)),[]);
title('DFT with notch filter applied');

%do the inverse fft
ImageIfft = abs(ifft2(Image_FFT.*fftshift(Filter)));
%chose only the relevant part
ImageFilt = ImageIfft(1:ImgS(1), 1:ImgS(2));

%plot everything
subplot(2,2,4);
imshow(uint8(ImageFilt));
title('filtered image');
