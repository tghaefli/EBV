clear 'all'
close 'all';

Cmap = colormap(jet);
Cmap(1,:) = 0;
figureIndex = 1;
%% Blue Screen Methode
%read image
Image = imread('Faces.png');
% Background Image, wird ben�tigt um Pixel zu ersetzen
ImageBackground = imread('backgr.png');


%transform to YCbCr space
ImageYCbCr = rgb2ycbcr(Image);
%extract color planes
Y = ImageYCbCr(:,:,1);
Cb = ImageYCbCr(:,:,2);
Cr = ImageYCbCr(:,:,3);

%from the figure 1 we found a transparency (blue) color 
TrCol = [130 160];

%the limit values, choose with imtools
LimitVal = 30;

%find the 2D indices of all pixel with distance larger than LimitVal
IndexImg = (double(Cb)-TrCol(1)).^2+(double(Cr)-TrCol(2)).^2 < LimitVal.^2;

%% Kontrolle zum Schauen welche Pixel ersetzt wurden ----------------------
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
figure(figureIndex)
figureIndex = figureIndex + 1;
imshow(ImageM, []);
title('overlay using YCbCr colorspace');

%% Morphologische Operationen durchf�hren
StrucElem = strel('disk', 6);
IndexImg = imclose(IndexImg, StrucElem);
IndexImg = imerode(IndexImg, StrucElem);

%% Bearbeitetes Bin�rbild ausgeben 
figure(figureIndex);
figureIndex = figureIndex + 1;
imshow(IndexImg);

%% Bounding Boxen Zeichen und Objekte z�hlen
%connected component labeling 
[LabelImage, NumberLabels] = bwlabel(IndexImg);
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
title(strcat('Number of Students: ',int2str(NumberLabels)));
cmap = colormap('gray');
imwrite(uint8(Image),cmap, 'DetectedFaces.png', 'png');

