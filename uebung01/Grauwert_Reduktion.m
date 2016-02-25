clear 'all';
close 'all';

%read image
Image = imread('London.png');

%plot the image
figure(1);
subplot(2,2,1);
imshow(Image);
title('8 bit');

%reduce gray values by 4 and plot
Image1 = Image/2^(8-6)*2^(8-6);        % 2^(cur_bit - wanted_bit)
subplot(2,2,2);
imshow(Image1);
title('6 bit');

%reduce gray values by 16 and plot
Image2 = Image/2^(8-4)*2^(8-4);
subplot(2,2,3);
imshow(Image2);
title('4 bit');

%reduce gray values by 64 and plot
%Image3 = Image/2^(8-2)*2^(8-2);
Image3 = bitshift(bitshift(Image,-6),6);
subplot(2,2,4);
imshow(Image3);
title('2 bit');

