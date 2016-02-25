clear 'all';
close 'all';

%read image
Image = imread('London.png');

%calculate the mean and standard deviatione (square root of variance)
sprintf(' using matlabs own functions:\n mean = %4.2f \t standard deviation = %4.2f', mean2(Image), std2(Image))

%now we do the same thing using the histogram ?????
%get histogram values
[Count, Value] = imhist(Image);