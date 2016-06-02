clear all;  close all;  clc;

%read image
Image = imread('blue.jpg');
%read background
ImageBackground = imread('back.jpg');

%convert to double for calculation
Image = double(Image);

Sy = size(Image,1);
Sx = size(Image,2);

%extract color planes
Red = Image(:,:,1);
Green = Image(:,:,2);
Blue = Image(:,:,3);

%figure(1)
%subplot(3,1,1)
%imshow(Red, []);
%subplot(3,1,2)
%imshow(Green, [])
%subplot(3,1,3)
%imshow(Blue, []);




%from the imtool we found a transparency (blue) color in rgb space
TrCol = [80 100 220];

%choose limit values using imtools and some trial and error
LimitVal = 100;

%find the 2D indices of all pixel with distance smaller than LimitVal
sphere = 1;
if sphere
    IndexImg = (Red-TrCol(1)).^2 + (Green-TrCol(2)).^2 + (Blue-TrCol(3)).^2 < LimitVal.^2;
else
    IndexImg =  (abs(Red-TrCol(1))<LimitVal) & ...
                (abs(Green-TrCol(2))<LimitVal) & ...
                (abs(Blue-TrCol(3))<LimitVal);
end     

%do the merge of the two images
RedBkgr = ImageBackground(:,:,1);
GreenBkgr = ImageBackground(:,:,2);
BlueBkgr = ImageBackground(:,:,3);

Red(IndexImg) = RedBkgr(IndexImg);
Green(IndexImg) = GreenBkgr(IndexImg);
Blue(IndexImg) = BlueBkgr(IndexImg);

ImageM = uint8(zeros(size(Image)));
ImageM(:,:,1) = Red(:,:);
ImageM(:,:,2) = Green(:,:);
ImageM(:,:,3) = Blue(:,:);
%plot it
figure(2)
imshow(ImageM, []);
title('overlay using RGB colorspace');

%do a three 3 representation
%extract color planes
Red = Image(:,:,1);
Green = Image(:,:,2);
Blue = Image(:,:,3);
%find LINEAR indices of background 
IndexBgr = find(IndexImg);
%extract the red/green/blue vectors of background
XVal = Red(IndexBgr);
YVal = Green(IndexBgr);
ZVal = Blue(IndexBgr);
%plot the values in the RGB color space
figure(3);hold on
%background
plot3(double(XVal)/255,double(YVal)/255,double(ZVal)/255,'bo');


IndexFgr = find(~IndexImg);
XVal = Red(IndexFgr);
YVal = Green(IndexFgr);
ZVal = Blue(IndexFgr);
%foreground
plot3(double(XVal)/255,double(YVal)/255,double(ZVal)/255,'yx');
legend('blue background', 'foreground pixel');

%box
plot3([0 1 1 0 0],[0 0 1 1 0],[0 0 0 0 0],'r-');
plot3([0 1 1 0 0],[0 0 1 1 0],[1 1 1 1 1],'r-');
plot3([0 0 1 1 0],[0 0 0 0 0],[0 1 1 0 0],'r-');
plot3([0 0 1 1 0],[1 1 1 1 1],[0 1 1 0 0],'r-');
plot3([0 1],[0 1],[0 1],'g-','LineWidth',2);
axis([0 1 0 1 0 1 0 1])
xlabel('R')
ylabel('G')
zlabel('B')
title('RGB color space with background pixel position')



%return
%%
close all;  clear all;  clc;

%now we do the same thing using the ycbcr color space

%read image again: YCbCr CONVERSION OF DOUBLE IMAGE DOES NOT WORK CORRECTLY
Image = imread('blue.jpg');
%read background
ImageBackground = imread('back.jpg');

%transform to YCbCr space
ImageYCbCr = rgb2ycbcr(Image);

%convert to double for calculation
ImageYCbCr = double(ImageYCbCr);

%extract color planes
Y = ImageYCbCr(:,:,1);
Cb = ImageYCbCr(:,:,2);
Cr = ImageYCbCr(:,:,3);

%from the figure 1 we found a transparency (blue) color (only Cb Cr)
TrCol = [240 0];

%choose limit values using imtools and some trial and error
LimitVal = 150;

%find the 2D indices of all pixel with distance larger than LimitVal
sphere = 1;
if sphere
    IndexImg = (Cb-TrCol(1)).^2 + (Cr-TrCol(2)).^2 < LimitVal.^2;
else
    IndexImg = (abs(Cb-TrCol(1))<LimitVal) & (abs(Cr-TrCol(2))<LimitVal);
end 

%extract color planes
Red = Image(:,:,1);
Green = Image(:,:,2);
Blue = Image(:,:,3);

%do the merge of the two images
RedBkgr = ImageBackground(:,:,1);
GreenBkgr = ImageBackground(:,:,2);
BlueBkgr = ImageBackground(:,:,3);

Red(IndexImg) = RedBkgr(IndexImg);
Green(IndexImg) = GreenBkgr(IndexImg);
Blue(IndexImg) = BlueBkgr(IndexImg);

ImageM = uint8(zeros(size(Image)));
ImageM(:,:,1) = Red(:,:);
ImageM(:,:,2) = Green(:,:);
ImageM(:,:,3) = Blue(:,:);

%plot it
figure(4)
imshow(ImageM, []);
title('overlay using YCbCr colorspace');

%find LINEAR indices of background (not white)
IndexBgr = find(IndexImg);

%define individual color planes
Y = ImageYCbCr(:,:,1);
Cb = ImageYCbCr(:,:,2);
Cr = ImageYCbCr(:,:,3);

%extract the red/green/blue vectors of background
XVal = Y(IndexBgr);
YVal = Cb(IndexBgr);
ZVal = Cr(IndexBgr);

figure(5);hold on
plot(double(YVal),double(ZVal),'bo');

IndexFgr = find(~IndexImg);
XVal = Y(IndexFgr);
YVal = Cb(IndexFgr);
ZVal = Cr(IndexFgr);
plot(double(YVal),double(ZVal),'yx');
plot(TrCol(1), TrCol(2), 'co');

plot([16 240],[16 240],'g-','LineWidth',2);
axis([16 240 16 240])
xlabel('Cb')
ylabel('Cr')
title('YCbCr color space with background pixel position')

