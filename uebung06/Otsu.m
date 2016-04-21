clear all;  close all;  clc;

%read image (try coins.png, kristall.png, Muenzen.png, Text1.png, Text2.png, Text3.png
Image = imread('coins.png');
if size(Image,3) == 3
    Image = rgb2gray(Image);
end

%plot it
figure(1)
subplot(1,2,1)
imshow(Image)
title('original image');

%determine image histogram
[Hist, Value] = imhist(Image);
%normalize it
RelFreq = Hist/sum(Hist);
%determine mean
MW = RelFreq'*Value;

%own implementation
Threshold = OwnOtsu(Image);

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

%do the threshold operation
ImageThr = Image > Threshold;
figure(1)
subplot(1,2,2)
imshow(ImageThr, [])
title('binary image');