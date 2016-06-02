%
% Hough transformation
%
clear all;  close all;  clc;

%read image
Image = imread('Strasse.png');
%plot it
figure(1);
subplot(3,1,1);
imshow(Image);
title('original image');

% Detect the edges, the result is a binary image
EdgeCanny = edge(Image, 'canny', [0 0.1], 1);
%plot it
subplot(3,1,2);
imshow(EdgeCanny, []);
title('Canny edge detection');

freezeColors ;

figure(2)
hold on
% Hough transformation, calculate the accumulator Hough
[Hough, Theta, Rho] = hough(EdgeCanny, 'RhoResolution', 2);

imshow(mat2gray(Hough));
colormap('hot');
xlabel('Theta');
ylabel('Rho')
title('Hough Accumulator');

hold off
unfreezeColors;

% Find at most 2 peaks with threshold 15 and minimim distance of 15, 15
% pixel
NumPeaks = 4;
HoughPeaks = houghpeaks(Hough, NumPeaks); %????????????? houghpeaks()


% Find the lines that correspond to the peaks; fill gabs of 15 pixel and
% suppress all (merged lines) that have a length less than 30 pixel
%Lines = houghlines(EdgeCanny, Theta, Rho, HoughPeaks, 'MinLength',200);%???????????? houghlines()
Lines = houghlines(EdgeCanny, Theta, Rho, HoughPeaks);%???????????? houghlines()
%figure(1)
subplot(3,1,3)

imshow(Image);
title('original image with hough lines');
hold on;

% Draw Lines an d
for k = 1:length(Lines)
    XY = [Lines(k).point1; Lines(k).point2];
    line(XY(:,1),XY(:,2),'LineWidth',2,'Color','red');
    XY = (Lines(k).point1+Lines(k).point2)/2;
    TheText = sprintf('rho = %d, alpha = %2.2f', Lines(k).rho, Lines(k).theta);
    text(XY(1), XY(2), TheText, 'BackgroundColor',[.7 .7 .7]);
end
 