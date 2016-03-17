clear 'all';
close 'all';

%read image
Image = imread('skeleton.png');

%initialize the thinning
ImageIn = Image;
ImageOut = DoThinning(ImageIn);
figure(1);
imshow(ImageOut, []);
title('Hit Miss');

%start the recursion
while mean2(ImageIn ~= ImageOut) > 0 %we have a difference
    ImageIn = ImageOut;
    ImageOut = DoThinning(ImageIn);
    figure(1);
    imshow(ImageOut, []);
    title('Hit Miss');  
end