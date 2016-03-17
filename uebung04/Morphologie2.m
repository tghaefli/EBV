%read image
Image = imread('2CV.png');

%plot the image
figure(1);
subplot(2,2,1);
imshow(Image);
title('Original');

%apply threshold opertion
ImageThr = Image > 100;

%plot 
subplot(2,2,2);
imshow(ImageThr, [0 1]);
title('Threshold');

%define the structure elements ??????
StrucElem1 = ones(1,1)
StrucElem2 = ones(1,1)
StrucElemTot = ones(1,1)

%do a dilation ????
ImageDil = ImageThr;

%plot 
subplot(2,2,3);
imshow(ImageDil);
title('Dilation 5x7');

%do a successive dilation ?????
ImageDil1 = ImageThr;
ImageDil12 = ImageDil1;
%plot
subplot(2,2,4);
imshow(ImageDil12);
title('Dilation 5x1 then 1x7');
