close all; clear all; clc;

i = 1;
Image = imread('Image_01.png');
ImageYCbCr = rgb2ycbcr(Image);

Img_Y  = ImageYCbCr(:,:,1);
Img_Cb = ImageYCbCr(:,:,2);
Img_Cr = ImageYCbCr(:,:,3);

%imshow(Image,[]); imtool(Img_Cb); imtool(Img_Cr);

Thr_Red    = [115 , 185];  %[Cb,Cr]
Thr_Green  = [115 , 126];
Thr_Blue   = [150 , 120];
Thr_Yellow = [83  , 150];

Limit_Red    = 20;
Limit_Green  = 8;
Limit_Blue   = 15;
Limit_Yellow = 20;

% Locate items
Index_Red    = (double(Img_Cb)-Thr_Red(1)).^2    + (double(Img_Cr)-Thr_Red(2)).^2    < Limit_Red.^2;
Index_Green  = (double(Img_Cb)-Thr_Green(1)).^2  + (double(Img_Cr)-Thr_Green(2)).^2  < Limit_Green.^2;
Index_Blue   = (double(Img_Cb)-Thr_Blue(1)).^2   + (double(Img_Cr)-Thr_Blue(2)).^2   < Limit_Blue.^2;
Index_Yellow = (double(Img_Cb)-Thr_Yellow(1)).^2 + (double(Img_Cr)-Thr_Yellow(2)).^2 < Limit_Yellow.^2;


% open and close
size_open  = 10;
size_close = ceil(size_open*1.2);
Index_Red    = imopen(Index_Red,    strel('disk', size_open));       Index_Red    = imclose(Index_Red,   strel('disk', size_close));
Index_Green  = imopen(Index_Green,  strel('disk', size_open));       Index_Green  = imclose(Index_Green, strel('disk', size_close));
Index_Blue   = imopen(Index_Blue,   strel('disk', size_open));       Index_Blue   = imclose(Index_Blue,  strel('disk', size_close));
Index_Yellow = imopen(Index_Yellow, strel('disk', size_open));       Index_Yellow = imopen(Index_Yellow, strel('disk', size_close));




figure(i);
subplot(2,3,1); imshow(Image, []);      title('All');

Prop = regionprops(Index_Red,'Centroid');
for Ind=1:numel(Prop) 
    Cent=Prop(Ind).Centroid;
    X=Cent(1);Y=Cent(2);
    line([X-10 X+10],[Y Y]);
    line([X X],[Y-10 Y+10]);
    text(X,Y-40,sprintf('red')); 
end
Prop = regionprops(Index_Green,'Centroid');
for Ind=1:numel(Prop) 
    Cent=Prop(Ind).Centroid;
    X=Cent(1);Y=Cent(2);
    line([X-10 X+10],[Y Y]);
    line([X X],[Y-10 Y+10]);
    text(X,Y-40,sprintf('green')); 
end
Prop = regionprops(Index_Blue,'Centroid');
for Ind=1:numel(Prop) 
    Cent=Prop(Ind).Centroid;
    X=Cent(1);Y=Cent(2);
    line([X-10 X+10],[Y Y]);
    line([X X],[Y-10 Y+10]);
    text(X,Y-40,sprintf('blue')); 
end
Prop = regionprops(Index_Yellow,'Centroid');
for Ind=1:numel(Prop) 
    Cent=Prop(Ind).Centroid;
    X=Cent(1);Y=Cent(2);
    line([X-10 X+10],[Y Y]);
    line([X X],[Y-10 Y+10]);
    text(X,Y-40,sprintf('yellow')); 
end


subplot(2,3,2); imshow(Index_Red);      title('Red');
subplot(2,3,3); imshow(Index_Green);    title('Green');
subplot(2,3,4); imshow(Index_Blue);     title('Blue');
subplot(2,3,5); imshow(Index_Yellow);   title('Yellow');



