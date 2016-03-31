clear 'all'

%read image
Image =  rgb2gray(imread('unblur.png')) ;

%construct the maks
Mask = fspecial('gaussian',7,10);

%sigma of added gaussian noise
V = .000;

%apply noise and blur
BlurredNoisy = imnoise(imfilter(Image,Mask),'gaussian',0, V);
%save the image
imwrite(BlurredNoisy, 'blur.png', 'png');

%image buffer for the result
WT = zeros(size(Image));
WT(5:end-4,5:end-4) = 1;

%we assume to now only the size of the mask
InitMask = ones(size(Mask));
%perform deconvolution
[J P] = deconvblind(double(BlurredNoisy),InitMask,20,10*sqrt(V),WT);

%plot it
subplot(221);imshow(BlurredNoisy, [0 255]);
title('Blurred and Noisy Image');
subplot(222);imshow(Mask,[]);
title('True Mask');
subplot(223);imshow(J, [0 255]);
title('Deblurred Image');
subplot(224);imshow(P,[]);
title('Recovered Mask');