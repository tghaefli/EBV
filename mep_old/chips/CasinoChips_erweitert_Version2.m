clear 'all'
close 'all';

Cmap = colormap(jet);
Cmap(1,:) = 0;
figureIndex = 1;

%read image
Image = imread('Chips_01.png');
Image2=Image;
% Background Image, wird benötigt um Pixel zu ersetzen
ImageBackground = imread('chipsbackgr.png');

%% Alle Chips finden
%transform to YCbCr space
ImageYCbCr = rgb2ycbcr(Image);
%extract color planes
Y = ImageYCbCr(:,:,1);
Cb = ImageYCbCr(:,:,2);
Cr = ImageYCbCr(:,:,3);

%from the figure 1 we found a transparency (blue) color 
TrCol = [120 50];

%the limit values, choose with imtools
LimitVal = 50;

%find the 2D indices of all pixel with distance larger than LimitVal
IndexImg = (double(Cb)-TrCol(1)).^2+(double(Cr)-TrCol(2)).^2 < LimitVal.^2;

% Bild invertieren, um einfacher weiterarbeiten zu können
IndexImg = ~IndexImg;
%define the structure element
StrucElem = strel('disk', 6);
StrucElem2 = strel('disk', 40);
StrucElem3 = strel('disk', 10);
%Binär-Bild mit morphologischen Operationen bearbeiten
IndexImg2 = imclose(IndexImg, StrucElem);
IndexImg4 = imerode(IndexImg2, StrucElem2);
% IndexImg4 = imdilate(IndexImg3,StrucElem3);
Index1=IndexImg4;

% % Bearbeitetes Binärbild ausgeben ----------------------------------------
% figure(figureIndex);
% figureIndex = figureIndex + 1;
% imshow(IndexImg4);
% % ------------------------------------------------------------------------

% Nur die Detektierten Stellen anzeigen
I1=Image2(:,:,1);
I2=Image2(:,:,2);
I3=Image2(:,:,3);
I1(IndexImg4==0) = 0;
I2(IndexImg4==0) = 0;
I3(IndexImg4==0) = 0;
I4(:,:,1)=I1;
I4(:,:,2)=I2;
I4(:,:,3)=I3;

figure(figureIndex);
figureIndex = figureIndex + 1;
imshow(I4);

%connected component labeling 
[LabelImage, NumberLabels] = bwlabel(IndexImg4);
%do feature extraction 
Prop = regionprops(LabelImage,'BoundingBox','Centroid');
figure(figureIndex);
figureIndex = figureIndex + 1;
imshow(Image);
for Ind=1:size(Prop,1) 
    Cent=Prop(Ind).Centroid;   
    X=Cent(1);Y=Cent(2);
    BBox = Prop(Ind).BoundingBox;
    %construct the bounding box using line or rectangle
    rectangle('Position', BBox, 'EdgeColor',[0 1 0]);       
end
title(strcat('Number of ALL Chips: ',int2str(NumberLabels)));

%% Weisse Chips herausfiltern
%transform to YCbCr space
Image3=rgb2ycbcr(I4);
%extract color planes
TrCol = [200 200];

%the limit values, choose with imtools
LimitVal = 80;
Red = I4(:,:,1);
Green = I4(:,:,2);
Blue = I4(:,:,3);
%find the 2D indices of all pixel with distance larger than LimitVal
IndexImg = (double(Green)-TrCol(1)).^2+(double(Blue)-TrCol(2)).^2 < LimitVal.^2;
IndexImgSec = (double(Green)-TrCol(1)).^2+(double(Red)-TrCol(2)).^2 < LimitVal.^2;
IndexImg=IndexImg&IndexImgSec;
% Bild invertieren, um einfacher weiterarbeiten zu können
%IndexImg = ~IndexImg;
%define the structure element
StrucElem = strel('disk', 10);
StrucElem2 = strel('disk', 20);
StrucElem3 = strel('disk', 10);
StrucElem4 = strel('disk', 20);
%Binär-Bild mit morphologischen Operationen bearbeiten
IndexImg4 = imclose(IndexImg, StrucElem);
%IndexImg3 = imdilate(IndexImg2, StrucElem2);
%IndexImg4 = imerode(IndexImg2,StrucElem3);
Index2=IndexImg4;
% figure(figureIndex)
% figureIndex = figureIndex + 1;
% imshow(IndexImg4);

% % Zur Kontrolle, um zu schauen welche Pixel gewählt wurden ---------------
% % extract color planes
% Red = Image3(:,:,1);
% Green = Image3(:,:,2);
% Blue = Image3(:,:,3);
% 
% %do the merge of the two images
% RedBkgr = ImageBackground(:,:,1);
% GreenBkgr = ImageBackground(:,:,2);
% BlueBkgr = ImageBackground(:,:,3);
% 
% Red(IndexImg) = RedBkgr(IndexImg);
% Green(IndexImg) = GreenBkgr(IndexImg);
% Blue(IndexImg) = BlueBkgr(IndexImg);
% 
% ImageM = uint8(zeros(size(Image)));
% ImageM(:,:,1) = Red(:,:);
% ImageM(:,:,2) = Green(:,:);
% ImageM(:,:,3) = Blue(:,:);
% 
% %plot it
% figure(figureIndex)
% figureIndex = figureIndex + 1;
% imshow(ImageM, []);
% title('weiss gefiltert');
% %-------------------------------------------------------------------------


%connected component labeling 
[LabelImage, NumberLabels] = bwlabel(IndexImg4);
%do feature extraction 
Prop = regionprops(LabelImage,'BoundingBox','Centroid');
figure(figureIndex);
figureIndex = figureIndex + 1;
imshow(Image);
for Ind=1:size(Prop,1) 
    Cent=Prop(Ind).Centroid;   
    X=Cent(1);Y=Cent(2);
    BBox = Prop(Ind).BoundingBox;
    %construct the bounding box using line or rectangle
    rectangle('Position', BBox, 'EdgeColor',[0 1 0]);       
end
title(strcat('Number of WHITE Chips: ',int2str(NumberLabels)));

%% Rote Chips herausfiltern
%extract color planes
% TrCol = [R G B]
TrCol = [227 40 78];

%the limit values, choose with imtools
LimitVal = 50;
Red = I4(:,:,1);
Green = I4(:,:,2);
Blue = I4(:,:,3);
%find the 2D indices of all pixel with distance larger than LimitVal
IndexImg = (double(Green)-TrCol(2)).^2+(double(Blue)-TrCol(3)).^2 < LimitVal.^2;
IndexImgSec = (double(Green)-TrCol(2)).^2+(double(Red)-TrCol(1)).^2 < LimitVal.^2;
IndexImg=IndexImg&IndexImgSec;
% Bild invertieren, um einfacher weiterarbeiten zu können
%IndexImg = ~IndexImg;
%define the structure element
StrucElem = strel('disk', 10);
StrucElem2 = strel('disk', 20);
StrucElem3 = strel('disk', 10);
StrucElem4 = strel('disk', 20);
%Binär-Bild mit morphologischen Operationen bearbeiten
IndexImg4 = imclose(IndexImg, StrucElem);
%IndexImg3 = imdilate(IndexImg2, StrucElem2);
%IndexImg4 = imerode(IndexImg2,StrucElem3);
Index3=IndexImg4;
% figure(figureIndex)
% figureIndex = figureIndex + 1;
% imshow(IndexImg4);

% % Zur Kontrolle, um zu schauen welche Pixel gewählt wurden ---------------
% % extract color planes
% Red = Image3(:,:,1);
% Green = Image3(:,:,2);
% Blue = Image3(:,:,3);
% 
% %do the merge of the two images
% RedBkgr = ImageBackground(:,:,1);
% GreenBkgr = ImageBackground(:,:,2);
% BlueBkgr = ImageBackground(:,:,3);
% 
% Red(IndexImg) = RedBkgr(IndexImg);
% Green(IndexImg) = GreenBkgr(IndexImg);
% Blue(IndexImg) = BlueBkgr(IndexImg);
% 
% ImageM = uint8(zeros(size(Image)));
% ImageM(:,:,1) = Red(:,:);
% ImageM(:,:,2) = Green(:,:);
% ImageM(:,:,3) = Blue(:,:);
% 
% %plot it
% figure(figureIndex)
% figureIndex = figureIndex + 1;
% imshow(ImageM, []);
% title('weiss gefiltert');
% %-------------------------------------------------------------------------


%connected component labeling 
[LabelImage, NumberLabels] = bwlabel(IndexImg4);
%do feature extraction 
Prop = regionprops(LabelImage,'BoundingBox','Centroid');
figure(figureIndex);
figureIndex = figureIndex + 1;
imshow(Image);
for Ind=1:size(Prop,1) 
    Cent=Prop(Ind).Centroid;   
    X=Cent(1);Y=Cent(2);
    BBox = Prop(Ind).BoundingBox;
    %construct the bounding box using line or rectangle
    rectangle('Position', BBox, 'EdgeColor',[0 1 0]);       
end
title(strcat('Number of RED Chips: ',int2str(NumberLabels)));

%% Blaue Chips herausfiltern
%extract color planes
% TrCol = [R G B]
TrCol = [50 90 140];

%the limit values, choose with imtools
LimitVal = 74;
Red = I4(:,:,1);
Green = I4(:,:,2);
Blue = I4(:,:,3);
%find the 2D indices of all pixel with distance larger than LimitVal
IndexImg = (double(Green)-TrCol(2)).^2+(double(Blue)-TrCol(3)).^2 < LimitVal.^2;
IndexImgSec = (double(Green)-TrCol(2)).^2+(double(Red)-TrCol(1)).^2 < LimitVal.^2;
IndexImg=IndexImg&IndexImgSec;
% Bild invertieren, um einfacher weiterarbeiten zu können
%IndexImg = ~IndexImg;
%define the structure element
StrucElem = strel('disk', 10);
StrucElem2 = strel('disk', 20);
StrucElem3 = strel('disk', 10);
StrucElem4 = strel('disk', 20);
%Binär-Bild mit morphologischen Operationen bearbeiten
IndexImg4 = imclose(IndexImg, StrucElem);
%IndexImg3 = imdilate(IndexImg2, StrucElem2);
%IndexImg4 = imerode(IndexImg2,StrucElem3);
Index4=IndexImg4;
% figure(figureIndex)
% figureIndex = figureIndex + 1;
% imshow(IndexImg4);

% % Zur Kontrolle, um zu schauen welche Pixel gewählt wurden ---------------
% % extract color planes
% Red = Image3(:,:,1);
% Green = Image3(:,:,2);
% Blue = Image3(:,:,3);
% 
% %do the merge of the two images
% RedBkgr = ImageBackground(:,:,1);
% GreenBkgr = ImageBackground(:,:,2);
% BlueBkgr = ImageBackground(:,:,3);
% 
% Red(IndexImg) = RedBkgr(IndexImg);
% Green(IndexImg) = GreenBkgr(IndexImg);
% Blue(IndexImg) = BlueBkgr(IndexImg);
% 
% ImageM = uint8(zeros(size(Image)));
% ImageM(:,:,1) = Red(:,:);
% ImageM(:,:,2) = Green(:,:);
% ImageM(:,:,3) = Blue(:,:);
% 
% %plot it
% figure(figureIndex)
% figureIndex = figureIndex + 1;
% imshow(ImageM, []);
% title('weiss gefiltert');
% %-------------------------------------------------------------------------


%connected component labeling 
[LabelImage, NumberLabels] = bwlabel(IndexImg4);
%do feature extraction 
Prop = regionprops(LabelImage,'BoundingBox','Centroid');
figure(figureIndex);
figureIndex = figureIndex + 1;
imshow(Image);
for Ind=1:size(Prop,1) 
    Cent=Prop(Ind).Centroid;   
    X=Cent(1);Y=Cent(2);
    BBox = Prop(Ind).BoundingBox;
    %construct the bounding box using line or rectangle
    rectangle('Position', BBox, 'EdgeColor',[0 1 0]);       
end
title(strcat('Number of BLUE Chips: ',int2str(NumberLabels)));

