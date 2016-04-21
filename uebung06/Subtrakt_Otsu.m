clear all;  close all;  clc;

%read image (try coin.png, kristall.png, Text1.png, Text2.png, Text3.png
Image = imread('Text3.png');

%apply a smoothing filter (we have to know the approximate size of
%forground objects)
sigma = 85;
Mask = fspecial('gaussian', 40, sigma);

%ImageFilt = imfilter(Image, Mask, 'symmetrie');
ImageFilt = imfilter(Image, Mask);


%subtract the filtered image from the orginal image; 
Diff = (double(Image)-double(ImageFilt));
%everything below could be done in double; but we want to keep standard 8-bit
%images and have to shift the difference; this can be obtained with 1D histogramm:  
[Hist, Vals] = hist(Diff(:));
Diff = uint8(Diff-Vals(1));

%plot everything
figure(1)
subplot(2,2,1);
imshow(Image)
title('original image');

subplot(2,2,2);
imshow(ImageFilt, [])
title('smoothed image');

subplot(2,2,3);
imshow(Diff, [])
title('difference image');

%apply Otsu in difference image
Threshold = 255*graythresh(Diff);
ImageBW = Diff > Threshold;
subplot(2,2,4);
imshow(ImageBW, [])
title('binary image');

%determine image histogram
[Hist, Value] = imhist(Image);
%normalize it
RelFreq = Hist/sum(Hist);
%determine mean
MW = RelFreq'*Value;

%plot it
figure(2)
plot(Value, Hist, 'bo-')
%plot the lines representing the mean grey value and Otsu's method
line([Threshold Threshold], [0 max(Hist)],'LineWidth',1,'Color',[1 0 0]); 
line([MW MW], [0 max(Hist)/2],'LineWidth',1,'Color',[0 1 0]); 
legend('histogram','Otsu�s threshold','mean grey value');
title('image histogram')
xlabel('grey values')
ylabel('relative frequeny')

%try to obtain skeleton
figure(3)
imshow(bwmorph(bwmorph(~ImageBW,'close'),'thin','Inf'));
title('skeleton');
