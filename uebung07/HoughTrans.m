%
% Hough transformation
%
clear 'all';
close 'all'

%read image


useReal = 1;
%we can use a simple generated image for testing
if useReal == 1
    Image = imread('..\uebung01\London.png');
else
    %
    Image = zeros(100,200);    
    % Objekte hinzufüge
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
[Hough, Alpha, Rho] = hough(EdgeCanny);
figure(2)
imshow(mat2gray(Hough));
colormap('hot');
xlabel('Alpha');
ylabel('Rho')
title('Hough Accumulator');

% Find at most 5 peaks with threshold 15 and minimim distance of 15, 15
% pixel
NumPeaks = 5;
HoughPeaks = [];%?????????????

% Find the lines that correspond to the peaks; fill gabs of 15 pixel and
% suppress all (merged lines) that have a length less than 30 pixel
Lines = [];%????????????
figure(3)
imshow(Image);
title('original image with hough lines');
hold on;

for k = 1:length(Lines)
    XY = [Lines(k).point1; Lines(k).point2];
    line(XY(:,1),XY(:,2),'LineWidth',2,'Color','red');
    XY = (Lines(k).point1+Lines(k).point2)/2;
    TheText = sprintf('rho = %d, alpha = %d', Lines(k).rho, Lines(k).theta);
    text(XY(1), XY(2), TheText, 'BackgroundColor',[.7 .7 .7]);
end
 