clear 'all'
close 'all';

Cmap = colormap(jet);
Cmap(1,:) = 0;
figureIndex = 1;

%read image
ImageA = imread('Chips_01a.png');
ImageB = imread('Chips_01b.png');
% Background Image, wird benötigt um Pixel zu ersetzen
ImageBackground = imread('chipsbackgr.png');
%% Blue Screen Methode Bild A
%transform to YCbCr space
ImageYCbCr = rgb2ycbcr(ImageA);
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
StrucElem3 = strel('disk', 20);
% Binär-Bild mit morphologischen Operationen bearbeiten
IndexImg2 = imclose(IndexImg, StrucElem);
IndexImg3 = imerode(IndexImg2, StrucElem2);
IndexImg4 = imdilate(IndexImg3,StrucElem3);
IndexA=IndexImg4;

% % Zur Kontrolle, um zu schauen welche Pixel gewählt wurden (Auskommentieren)
% % extract color planes
% Red = ImageA(:,:,1);
% Green = ImageA(:,:,2);
% Blue = ImageA(:,:,3);
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
% ImageM = uint8(zeros(size(ImageA)));
% ImageM(:,:,1) = Red(:,:);
% ImageM(:,:,2) = Green(:,:);
% ImageM(:,:,3) = Blue(:,:);
% 
% %plot it
% figure(figureIndex)
% figureIndex = figureIndex + 1;
% imshow(ImageM, []);
% title('overlay using YCbCr colorspace');

% % Bearbeitetes Binärbild ausgeben (Auskommentieren)
% figure(figureIndex);
% figureIndex = figureIndex + 1;
% imshow(IndexImg4);


%% Blue Screen Methode Bild A
%transform to YCbCr space
ImageYCbCr = rgb2ycbcr(ImageB);
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
StrucElem3 = strel('disk', 20);
% Binär-Bild mit morphologischen Operationen bearbeiten
IndexImg2 = imclose(IndexImg, StrucElem);
IndexImg3 = imerode(IndexImg2, StrucElem2);
IndexImg4 = imdilate(IndexImg3,StrucElem3);
IndexB=IndexImg4;

% % Zur Kontrolle, um zu schauen welche Pixel gewählt wurden (Auskommentieren)
% % extract color planes
% Red = ImageB(:,:,1);
% Green = ImageB(:,:,2);
% Blue = ImageB(:,:,3);
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
% ImageM = uint8(zeros(size(ImageB)));
% ImageM(:,:,1) = Red(:,:);
% ImageM(:,:,2) = Green(:,:);
% ImageM(:,:,3) = Blue(:,:);
% 
% %plot it
% figure(figureIndex)
% figureIndex = figureIndex + 1;
% imshow(ImageM, []);
% title('overlay using YCbCr colorspace');

% Bearbeitetes Binärbild ausgeben (Auskommentieren)
% figure(figureIndex);
% figureIndex = figureIndex + 1;
% imshow(IndexImg4);

%% Bounding Boxen Zeichen und Objekte zählen
Index=(IndexA|IndexB);
Index=Index-IndexA;
StrucElem = strel('disk', 20);
Index=imopen(Index,StrucElem);


%connected component labeling 
[LabelImage, NumberLabels] = bwlabel(Index);
%do feature extraction 
Prop = regionprops(LabelImage,'BoundingBox','Centroid');
figure(figureIndex);
subplot(2,2,1);
title('Bild A');
imshow(ImageA);
for Ind=1:size(Prop,1) 
    Cent=Prop(Ind).Centroid;   
    X=Cent(1);Y=Cent(2);
    BBox = Prop(Ind).BoundingBox;
    %construct the bounding box using line or rectangle
    rectangle('Position', BBox, 'EdgeColor',[0 1 0]);       
end
title(strcat('Number of Differences: ',int2str(NumberLabels)));
subplot(2,2,2);
imshow(ImageB);
title('Bild B');

subplot(2,2,3);
imshow(Index);
title('Differenz-Bild');

