clear 'all';
close 'all';

%read image
Image = imread('London.png');

%plot the image
figure(1);
subplot(2,2,1);
imshow(Image);
title('London.png');

%get histogram values
[Count, Value] = imhist(Image);
%plot them
grid on
subplot(2,2,2);
plot(Value, Count, 'bo-');
xlabel('gray value');
ylabel('absolute frequency')


% relative and cumulative frequency
[sx, sy] = size(Image);
Count2 = Count/(sx*sy);
subplot(2,2,3);
plot(Value, Count2, 'go-');
xlabel('gray value');
ylabel('relative frequency')

% Histogram
B = cumsum(Count2);
subplot(2,2,4);
plot(Value, B, 'r-');
xlabel('gray value');
ylabel('cumultative frequency')
