clear all;
close all;
clc;

%read image
Image = imread('London.png');

%plot the image
figure(1);
subplot(2,2,1);
imshow(Image);
title('Original');



%apply a filter of size 2x2
filter1 = 1/(2^2)*ones(2,2);
Image1 = imfilter(Image, filter1, 'same');
%plot 
subplot(2,2,2);
imshow(Image1);
title('2 x 2 Filter');

%apply a filter of size 4x4
Image2 = imfilter(Image, ones(3)/(3^2), 'same');
%plot
subplot(2,2,3);
imshow(Image2);
title('4 x 4 Filter');

%apply a filter of size 8x8
%Image3 = imfilter(Image, ones(4)/(4^2), 'same');       % 16 op/pixel

Image3_tmp = double(imfilter(Image,1/4*ones(1,4)));     
Image3 = uint8(conv2(Image3_tmp,1/4*ones(4,1)));        % total of 8 op/pixel

%Mask [1,2,1]/4 * [1,2,1]'/4
Image3_tmp = double(imfilter(Image,1/4*[1,2,1]));
Image3 = uint8(conv2(Image3_tmp,1/4*[1,2,1]'));        % total of 6 op/pixel

%plot
subplot(2,2,4);
imshow(Image3);
title('8 x 8 Filter');

figure(2);hold on
plot(Image(200,:), 'bo-');
xlabel('x-Wert (Zeile 200)');
ylabel('Grauwert');
plot(Image1(200,:), 'r-');
plot(Image2(200,:), 'g-');
plot(Image3(200,:), 'c-');
legend('Original', '2 x 2 Filter', '4 x 4 Filter', '8 x 8 Filter');