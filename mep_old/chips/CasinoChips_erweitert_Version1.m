clear 'all'
close 'all';

Cmap = colormap(jet);
Cmap(1,:) = 0;
figureIndex = 1;
Number=0;

%read image
Image = imread('Chips_01.png');
% Background Image, wird benötigt um Pixel zu ersetzen
ImageBackground = imread('chipsbackgr.png');

%transform to YCbCr space
ImageYCbCr = rgb2ycbcr(Image);
%extract color planes
Y = ImageYCbCr(:,:,1);
Cb = ImageYCbCr(:,:,2);
Cr = ImageYCbCr(:,:,3);

%% ROTE CHIPS ----------------------------------------------------------------------
%from the figure 1 we found a transparency (blue) color 
TrCol = [115 200];

%the limit values, choose with imtools
LimitVal = 50;

%find the 2D indices of all pixel with distance larger than LimitVal
IndexImg = (double(Cb)-TrCol(1)).^2+(double(Cr)-TrCol(2)).^2 < LimitVal.^2;

% Bild invertieren, um einfacher weiterarbeiten zu können
%IndexImg = ~IndexImg;
%define the structure element
StrucElem = strel('disk', 20);
StrucElem2 = strel('disk', 20);
StrucElem3 = strel('disk', 6);
%Binär-Bild mit morphologischen Operationen bearbeiten
IndexImg2 = imclose(IndexImg, StrucElem);
% IndexImg3 = imopen(IndexImg2, StrucElem2);
% IndexImg4 = imdilate(IndexImg3,StrucElem3);
IndexImg4 = imopen(IndexImg2, StrucElem2);

% % Zur Kontrolle, um zu schauen welche Pixel gewählt wurden ---------------
% % extract color planes
% Red = Image(:,:,1);
% Green = Image(:,:,2);
% Blue = Image(:,:,3);
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
% title('overlay using YCbCr colorspace');
% %-------------------------------------------------------------------------
% 
% % Bearbeitetes Binärbild ausgeben ----------------------------------------
% figure(figureIndex);
% figureIndex = figureIndex + 1;
% imshow(IndexImg);
% % ------------------------------------------------------------------------
 


%connected component labeling 
[LabelImage, NumberLabels] = bwlabel(IndexImg4);
Number = Number + NumberLabels;
%do feature extraction 
Prop = regionprops(LabelImage,'BoundingBox','Centroid');
figure(figureIndex);
figureIndex = figureIndex + 1;
imshow(Image);
for Ind=1:size(Prop,1) 
    Cent=Prop(Ind).Centroid;   
    %X=Cent(1);Y=Cent(2);
    BBox = Prop(Ind).BoundingBox;
    %construct the bounding box using line or rectangle
    rectangle('Position', BBox, 'EdgeColor',[0 1 0]);       
end
title(strcat('Number of RED Chips: ',int2str(NumberLabels)));
%--------------------------------------------------------------------------


%% Blaue CHIPS ----------------------------------------------------------------------
%from the figure 1 we found a transparency (blue) color 
TrCol = [150 110];

%the limit values, choose with imtools
LimitVal = 20;

%find the 2D indices of all pixel with distance larger than LimitVal
IndexImg = (double(Cb)-TrCol(1)).^2+(double(Cr)-TrCol(2)).^2 < LimitVal.^2;

% Bild invertieren, um einfacher weiterarbeiten zu können
%IndexImg = ~IndexImg;
%define the structure element
StrucElem = strel('disk', 10);
StrucElem2 = strel('disk', 35);
StrucElem3 = strel('disk', 10);
%Binär-Bild mit morphologischen Operationen bearbeiten
IndexImg2 = imclose(IndexImg, StrucElem);
IndexImg3 = imopen(IndexImg2, StrucElem2);
IndexImg4 = imopen(IndexImg3,StrucElem3);

% % Zur Kontrolle, um zu schauen welche Pixel gewählt wurden ---------------
% % extract color planes
% Red = Image(:,:,1);
% Green = Image(:,:,2);
% Blue = Image(:,:,3);
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
% title('overlay using YCbCr colorspace');
% %-------------------------------------------------------------------------
% % 
% % Bearbeitetes Binärbild ausgeben ----------------------------------------
% figure(figureIndex);
% figureIndex = figureIndex + 1;
% imshow(IndexImg4);
% % ------------------------------------------------------------------------
 


%connected component labeling 
[LabelImage, NumberLabels] = bwlabel(IndexImg4);
Number = Number + NumberLabels;
%do feature extraction 
Prop = regionprops(LabelImage,'BoundingBox','Centroid');
figure(figureIndex);
figureIndex = figureIndex + 1;
imshow(Image);
for Ind=1:size(Prop,1) 
    Cent=Prop(Ind).Centroid;   
    %X=Cent(1);Y=Cent(2);
    BBox = Prop(Ind).BoundingBox;
    %construct the bounding box using line or rectangle
    rectangle('Position', BBox, 'EdgeColor',[0 1 0]);       
end
title(strcat('Number of BLUE Chips: ',int2str(NumberLabels)));
%--------------------------------------------------------------------------


%% Schwarze CHIPS ----------------------------------------------------------------------
%from the figure 1 we found a transparency (blue) color 
TrCol = [50 50];

%the limit values, choose with imtools
LimitVal = 50;
Red = Image(:,:,1);
Green = Image(:,:,2);
Blue = Image(:,:,3);
%find the 2D indices of all pixel with distance larger than LimitVal
%Vergleich mit RGB
%Da Blau und Rot die gleichen Anteile hat, muss man auf alle Farben
%vergleichen und am Schluss AND Verknüpfen
IndexImg = (double(Green)-TrCol(1)).^2+(double(Blue)-TrCol(2)).^2 < LimitVal.^2;
IndexImgSec = (double(Green)-TrCol(1)).^2+(double(Red)-TrCol(2)).^2 < LimitVal.^2;
IndexImg=IndexImg&IndexImgSec;
% Bild invertieren, um einfacher weiterarbeiten zu können
%IndexImg = ~IndexImg;
%define the structure element
StrucElem = strel('disk', 10);
StrucElem2 = strel('disk', 35);
StrucElem3 = strel('disk', 30);
StrucElem4 = strel('disk', 20);
%Binär-Bild mit morphologischen Operationen bearbeiten
IndexImg2 = imclose(IndexImg, StrucElem);
IndexImg3 = imopen(IndexImg2, StrucElem2);
IndexImg4 = imerode(IndexImg3,StrucElem3);
IndexImg5 = imdilate(IndexImg4,StrucElem4);

% % Zur Kontrolle, um zu schauen welche Pixel gewählt wurden --------
% % extract color planes
% Red = Image(:,:,1);
% Green = Image(:,:,2);
% Blue = Image(:,:,3);
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
% title('overlay using YCbCr colorspace');
% 
% % 
% % Bearbeitetes Binärbild ausgeben------
% figure(figureIndex);
% figureIndex = figureIndex + 1;
% imshow(IndexImg5);

%connected component labeling 
[LabelImage, NumberLabels] = bwlabel(IndexImg5);
Number = Number + NumberLabels;
%do feature extraction 
Prop = regionprops(LabelImage,'BoundingBox','Centroid');
figure(figureIndex);
figureIndex = figureIndex + 1;
imshow(Image);
for Ind=1:size(Prop,1) 
    Cent=Prop(Ind).Centroid;   
    %X=Cent(1);Y=Cent(2);
    BBox = Prop(Ind).BoundingBox;
    %construct the bounding box using line or rectangle
    rectangle('Position', BBox, 'EdgeColor',[0 1 0]);       
end
title(strcat('Number of BLACK Chips: ',int2str(NumberLabels)));
%--------------------------------------------------------------------------

%% Weisse CHIPS ------------------------------------------------------------
%from the figure 1 we found a transparency (blue) color 
TrCol = [200 200];

%the limit values, choose with imtools
LimitVal = 80;
Red = Image(:,:,1);
Green = Image(:,:,2);
Blue = Image(:,:,3);
%find the 2D indices of all pixel with distance larger than LimitVal
IndexImg = (double(Green)-TrCol(1)).^2+(double(Blue)-TrCol(2)).^2 < LimitVal.^2;
IndexImgSec = (double(Green)-TrCol(1)).^2+(double(Red)-TrCol(2)).^2 < LimitVal.^2;
IndexImg=IndexImg&IndexImgSec;
% Bild invertieren, um einfacher weiterarbeiten zu können
%IndexImg = ~IndexImg;
%define the structure element
StrucElem = strel('disk', 10);
StrucElem2 = strel('disk', 35);
StrucElem3 = strel('disk', 30);
StrucElem4 = strel('disk', 20);
%Binär-Bild mit morphologischen Operationen bearbeiten
IndexImg2 = imclose(IndexImg, StrucElem);
IndexImg3 = imopen(IndexImg2, StrucElem2);
IndexImg4 = imerode(IndexImg3,StrucElem3);
IndexImg5 = imdilate(IndexImg4,StrucElem4);

% % Zur Kontrolle, um zu schauen welche Pixel gewählt wurden ------
% % extract color planes
% Red = Image(:,:,1);
% Green = Image(:,:,2);
% Blue = Image(:,:,3);
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
% title('overlay using YCbCr colorspace');
% 
% % Bearbeitetes Binärbild ausgeben ----------
% figure(figureIndex);
% figureIndex = figureIndex + 1;
% imshow(IndexImg5);

%connected component labeling 
[LabelImage, NumberLabels] = bwlabel(IndexImg5);
Number = Number + NumberLabels;
%do feature extraction 
Prop = regionprops(LabelImage,'BoundingBox','Centroid');
figure(figureIndex);
figureIndex = figureIndex + 1;
imshow(Image);
for Ind=1:size(Prop,1) 
    Cent=Prop(Ind).Centroid;   
    %X=Cent(1);Y=Cent(2);
    BBox = Prop(Ind).BoundingBox;
    %construct the bounding box using line or rectangle
    rectangle('Position', BBox, 'EdgeColor',[0 1 0]);       
end
title(strcat('Number of WHITE Chips: ',int2str(NumberLabels)));
%--------------------------------------------------------------------------

%% ALLE Chips---------------------------------------------------------------
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
StrucElem3 = strel('disk', 20);
%Binär-Bild mit morphologischen Operationen bearbeiten
IndexImg2 = imclose(IndexImg, StrucElem);
IndexImg3 = imerode(IndexImg2, StrucElem2);
IndexImg4 = imdilate(IndexImg3,StrucElem3);

% % Zur Kontrolle, um zu schauen welche Pixel gewählt wurden ---------------
% % extract color planes
% Red = Image(:,:,1);
% Green = Image(:,:,2);
% Blue = Image(:,:,3);
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
% title('overlay using YCbCr colorspace');
% 
% % Bearbeitetes Binärbild ausgeben -------------
% figure(figureIndex);
% figureIndex = figureIndex + 1;
% imshow(IndexImg4);

%connected component labeling 
[LabelImage, NumberLabels] = bwlabel(IndexImg4);
%do feature extraction 
Prop = regionprops(LabelImage,'BoundingBox','Centroid');
figure(figureIndex);
figureIndex = figureIndex + 1;
imshow(Image);
for Ind=1:size(Prop,1) 
    Cent=Prop(Ind).Centroid;   
    %X=Cent(1);Y=Cent(2);
    BBox = Prop(Ind).BoundingBox;
    %construct the bounding box using line or rectangle
    rectangle('Position', BBox, 'EdgeColor',[0 1 0]);       
end
title(strcat('Number of ALL COLOR Chips: ',int2str(NumberLabels)));
text(10,10,strcat('Number of ALL COLOR Chips: ',int2str(Number)));
