clear 'all';
close 'all';

%read image
Image = imread('..\uebung01\London.png');
%transform to double to once and for all
Image = double(Image);

%plot the image
figure(1);
subplot(1,3,1);
imshow(uint8(Image));
title('Original');

%choose the filters
Sobel = 1;
if Sobel == 1
    DX = fspecial('sobel')';
    DY = fspecial('sobel');
else
    DX = fspecial('prewitt')';
    DY = fspecial('prewitt');
end

%apply the DX and DY filter
ImageDx = imfilter(Image, DX);
ImageDy = imfilter(Image, DY);

%calculate the norm of the derviative
ImageDr = sqrt(ImageDx.*ImageDx+ImageDy.*ImageDy);
%plot it
subplot(1,3,2);
imshow(ImageDr, []);
title('dI/dr');

Threshold = 40;
%apply a certain threshold
EdgeImage = (ImageDr > Threshold);
%plot it
subplot(1,3,3);
imshow(EdgeImage, []);
Title = sprintf('Edge Image using Threshold: %d', Threshold);
title(char(Title));

%upper and lower threshold for edge detection (relative to max gradient
%value)
Threshold = [0.0 0.05];
%width of Gaussian
Sigma = 1;
%apply a certain threshold
EdgeCanny = EdgeImage;%??????
%plot it
figure(2)
subplot(1,2,1);
imshow(EdgeCanny, []);
Title = sprintf('Canny edge detection with thresholds: [%1.2f,%1.2f] and sigma %2.2f', Threshold(1), Threshold(2), Sigma);
title(char(Title));

Threshold = [0.0 0.0015];
Sigma = 1;
%apply a certain threshold
EdgeCanny = EdgeImage;%??????
%plot it
figure(2)
subplot(1,2,2);
imshow(EdgeCanny, []);
Title = sprintf('Canny edge detection with thresholds: [%1.4f,%1.4f] and sigma %2.2f', Threshold(1), Threshold(2), Sigma);
title(char(Title));


