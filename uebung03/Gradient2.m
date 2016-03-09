clear 'all'
close 'all';

%read image
Image = imread('London.png');
%transform to double to once and for all
Image = double(Image);

%plot the image
figure(1);
subplot(1,2,1);
imshow(Image, []);
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

%calculate the norm of the derviative ??????????
ImageDr = ImageDx;
%plot it
subplot(1,2,2);
imshow(ImageDr, []);
title('dI/dr');

%determine the angle (atan2 gives back the whole interval ]-pi , pi[ )
Angle = pi+atan2(ImageDy, ImageDx);
%use only those values that are above a given threshold
%Angle(????????) = 0;
%plot it
figure(2)
imshow(Angle, []);
map=colormap(jet);
map(1,:) = 0;
colormap(map)
title('angle, [0, 2\pi]');
colorbar;




