clear 'all';
close 'all';

%set size of fft to be power of 2
SizeFFT = 128;

%create image with filter coefficients
Image = zeros(100, 100);
%defines the size of the filter
Size = 1;
%smoothing filter
Image(50-Size:50+Size,50-Size:50+Size) = 1;

%prewitt filter
Prew = [-1 -1 -1; 0 0 0; 1 1 1]';
ImagePrew = zeros(100, 100);
ImagePrew(49:51,49:51) = Prew(:,:);

%laplace filter
Lap = [0 -1 0; -1 4 -1; 0 -1 0];
ImageLap = zeros(100, 100);
ImageLap(49:51,49:51) = Lap(:,:);

%do the ffts
Image_FFT = fft2(Image, SizeFFT, SizeFFT);
ImagePrew_FFT = fft2(ImagePrew, SizeFFT, SizeFFT);
ImageLap_FFT = fft2(ImageLap, SizeFFT, SizeFFT);

%plot everything
figure(1);
subplot(2,2,1);
imshow(Image(45:55,45:55), []);
title('Original image (average filter) ZOOMED');
subplot(2,2,2);
MaxVal = Image_FFT(1);
imshow(abs(fftshift(Image_FFT)),[0 MaxVal]);
title('DFT');
subplot(2,2,4);
plot((abs(fftshift(Image_FFT(1,:)))),'bo-');
title('row 0 of DFT');
axis([1 SizeFFT  0 MaxVal]);

figure(2)
subplot(2,2,1);
imshow(ImagePrew(45:55,45:55), []);
title('Original image (Prewitt Filter) ZOOMED');
subplot(2,2,2);
imshow(abs(fftshift(ImagePrew_FFT)),[]);
title('DFT');
subplot(2,2,4);
plot((abs(fftshift(ImagePrew_FFT(1,:)))),'bo-');
title('row 0 of DFT');
axis([1 SizeFFT  0 MaxVal]);

figure(3)
subplot(2,2,1);
imshow(ImageLap(45:55,45:55), []);
title('Original image (Laplace Filter) ZOOMED');
subplot(2,2,2);
imshow(abs(fftshift(ImageLap_FFT)),[]);
title('DFT');
subplot(2,2,4);
plot((abs(fftshift(ImageLap_FFT(1,:)))),'bo-');
title('row 0 of DFT');
axis([1 SizeFFT  0 4]);
