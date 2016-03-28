clear all;
close all;
clc;


%read image and cast to double
Image = double(imread('London.png'));


%plot the image
figure(1);
subplot(1,2,1);
imshow(Image,[]);
title('Original');

%choose the filters
Sobel = 1;
if Sobel == 1
	DX = -fspecial('sobel')';%sign convention!!
   DY = DX';	
else
    DX = -fspecial('prewitt')';%sign convention!!
    DY = DX';    
end

%apply the DX and DY filter
ImageDx = imfilter(Image, DX);
ImageDy = imfilter(Image, DY);

%calculate the norm of the derviative
ImageDr = sqrt(ImageDx.^2 + ImageDy.^2);

%plot it
subplot(1,2,2);
imshow(ImageDr, []);
title('dI/dr');

%determine the angle (atan2 gives back the whole interval ]-pi , pi[ )
Angle = pi+atan2(ImageDy, ImageDx);
%use only those values that are above a given threshold

Angle(ImageDr < 40) = 0;	% Write result in ImageDr directly, without any assignment

% plot it
% Buggy for linux
figure(2)
figure(3)
imshow(Angle, []);
map=colormap(jet);
map(1,:) = 0;
colormap(map)
title('angle, [0, 2\pi]');
colorbar;

