clear 'all';
close 'all';

%read image
Image = imread('London.png');

%plot the image
figure(1);
subplot(1,2,1);
imshow(Image);
title('London.png');

%get histogram values
[Count, Value] = imhist(Image);
%plot them
subplot(1,2,2);
plot(Value, Count, 'bo-');
xlabel('gray value');
ylabel('absolute frequency')


%??? relative and cumulative frequency

