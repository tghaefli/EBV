%
% Hough transformation
%
clear all;  close all;  clc;

%read image


useReal = 1;
%we can use a simple generated image for testing
if useReal == 1
    Image = imread('../uebung01/London.png');
else
    %
    Image = zeros(100,200);    
    % Objekte hinzuf�ge
    Image([10:40],[20:40]) = 1;
    Image = mat2gray(Image);
    %may rotate
    Angle = 0;
    Image = imrotate(Image, Angle);
end

%plot it
figure(1);
subplot(1,2,1);
imshow(Image);
title('original image');

% Detect the edges, the result is a binary image
EdgeCanny = edge(Image, 'canny', [0 0.1], 1);
%plot it
subplot(1,2,2);
imshow(EdgeCanny, []);
title('Canny edge detection');

% Hough transformation, calculate the accumulator Hough
%[Hough, Alpha, Rho] = hough(EdgeCanny);     % Haftransformation
[Hough, Alpha, Rho] = hough(EdgeCanny, 'RhoResolution', 2, 'ThetaResolution', 0.2);     % Haftransformation
%Alpha: Von -90° bis 89°
% Roh:  Von -sqrt(size_x^2 + size_y^2) bis sqrt(size_x^2 + size_y^2)

% Manually change accumulator for test purpose
%Hough(300, 300) = 400;


figure(2)
imshow(mat2gray(Hough));
colormap('hot');
xlabel('Alpha');
ylabel('Rho')
title('Hough Accumulator');

% Find at most 5 peaks with threshold 15 and minimim distance of 15, 15
% pixel
NumPeaks = 5;
HoughPeaks = houghpeaks(Hough, NumPeaks); %????????????? houghpeaks()

% Find the lines that correspond to the peaks; fill gabs of 15 pixel and
% suppress all (merged lines) that have a length less than 30 pixel
Lines = houghlines(EdgeCanny, Alpha, Rho, HoughPeaks);%???????????? houghlines()
figure(3)
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
 