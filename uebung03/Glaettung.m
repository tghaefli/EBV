clear 'all';
close 'all';

%read image
Image = imread('London.png');

%plot the image
figure(1);
subplot(2,2,1);
imshow(Image);
title('Original');

%apply a filter of size 2x2
Image1 = Image;%?????
%plot 
subplot(2,2,2);
imshow(Image1);
title('2 x 2 Filter');

%apply a filter of size 4x4
Image2 = Image;%?????
%plot
subplot(2,2,3);
imshow(Image2);
title('4 x 4 Filter');

%apply a filter of size 8x8
Image3 = Image;%?????
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