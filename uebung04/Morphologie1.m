clear 'all';
close 'all';

%read image (is logical)
Image = imread('Morphologie.bmp');

%plot the image
figure(1);
subplot(2,2,1);
imshow(Image);
title('Original');

%define the structure element
StrucElem = ones(5,3);
StrucElem = ones(5,1);
StrucElem = eye(5);


%plot it (we use imdilate to plot the structure element)
subplot(2,2,2);
Help = uint8(zeros(size(Image)));
Help(size(Image,1)/2, size(Image,2)/2) = 1;
Help = imdilate(Help, StrucElem);
imshow(Help, []);
title('Structure Element');

%do a closure
ImageClose = imclose(Image, StrucElem);
ImageClose = 255*ImageClose;
ImageClose(Image ~= 0) = 128;

%plot 
subplot(2,2,3);
imshow(ImageClose, []);
title('Closing');

%do an opening
ImageOpen = imopen(Image,StrucElem);
Help = 255*ImageOpen;
Help(Image ~= ImageOpen) = 128;

%plot
subplot(2,2,4);
imshow(Help, []);
title('Opening');

