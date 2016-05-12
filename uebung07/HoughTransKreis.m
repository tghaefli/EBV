% Hough transformation
clear 'all';
close 'all';

%the interior of the circles must be lighter; otherwise set Invert -> 1
Invert = 1;

useReal = 1;
%a synthetic image can be used for testing
if useReal == 1
    %read image
    Image = imread('..\uebung04\kugeln.png');
    %Image = imread('..\uebung06\coins.png');
else    
    %empty image
    Image = zeros(100,150);
    %create a disk
    Disk = fspecial('disk', 27.5);
    %shortcut for size
    Siz = (size(Disk)-1)/2;
    %merge disk to image
    Image(size(Image,1)/2-Siz(1):size(Image,1)/2+Siz(1), size(Image,2)/2-Siz(2):size(Image,2)/2+Siz(2)) = Disk(:,:);       
end

figure(1);
imshow(Image, []);
title('original image');



%choose the filters
Sobel = 1;
if Sobel == 1
    DX = fspecial('sobel')';
    DY = fspecial('sobel');
else
    DX = fspecial('prewitt')';
    DY = fspecial('prewitt');
end

%apply the DX and DY filter (use symmetric boundary conditions to avoid
%border effects
ImageDx = imfilter(double(Image), DX, 'symmetric');
ImageDy = imfilter(double(Image), DY, 'symmetric');

%calculate the norm of the derviative
ImageDr = sqrt(ImageDx.*ImageDx+ImageDy.*ImageDy);

UseCanny = 0;
if UseCanny == 1
    %upper and lower threshold for edge detection (relative to max gradient
    %value)
    Threshold = [0.0 0.1];
    %width of Gaussian
    Sigma = 1;
    %apply a certain threshold
    [EdgeCanny, Threshold] = edge(Image,'canny', Threshold, Sigma);
    %plot it
    figure(2)
    imshow(EdgeCanny, []);
    Title = sprintf('Canny edge detection with thresholds: [%2.2f,%2.2f] and sigma %2.2f', Threshold(1), Threshold(2), Sigma);
    title(char(Title));

    %we use both the indices and the x-y-values of the edges
    Indices = find(EdgeCanny ~= 0);
    [Yw, Xw] = find(EdgeCanny ~= 0);
else
    %we require a threshold; the edges could also be chosen with a Canny edge
    %detection in parallel
    Threshold = 0.3*max(max(ImageDr));
    %we use both the indices and the x-y-values of the edges
    Indices = find(ImageDr > Threshold);
    [Yw, Xw] = find(ImageDr > Threshold);
    
    figure(2)
    imshow(ImageDr, []);
    title('Norm of gradient');
end

%this is the accumulator image
Acc = zeros(size(Image));
%here the range of radius' is chosen
for Radius = 22:33
    Dx = ImageDx(Indices);
    Dy = ImageDy(Indices);
    Dr = ImageDr(Indices);
    if Invert == 1
        xc = Xw+Radius*Dx./Dr;
        yc = Yw+Radius*Dy./Dr;
    else
        xc = Xw-Radius*Dx./Dr;
        yc = Yw-Radius*Dy./Dr;
    end
    %we construct all indices corresponding to a fixed radius
    Inds = round(yc)+size(Image,1)*(round(xc)-1);
    %map out values out of the image boundary
    Inds = Inds(0 < Inds & Inds < prod(size(Image))); 
    %accumulate
    Acc(Inds) = Acc(Inds)+1; 
end

%plot accumultor image
figure(3)
imshow(Acc, []);
title('accumulator image');

%select the maxima
ImageCenter = Acc > 0.5*max(max(Acc));
%plot them
figure(4)
imshow(ImageCenter, []);
title('maxima of accumulator image');

%do some morphology
ImageClose = bwmorph(ImageCenter, 'close');
ImageOpen = bwmorph(ImageClose, 'open');

%plot result
figure(5)
imshow(ImageOpen, []);
title('maxima of accumulator image after closure and opening');
