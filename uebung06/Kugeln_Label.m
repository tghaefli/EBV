clear 'all'
close 'all';

Cmap = colormap(jet);
Cmap(1,:) = 0;

%read image
Image = imread('kugeln.png');

%plot the image
figure(1);
subplot(2,2,1);
imshow(Image);
title('Original');

%apply threshold operation
ImageThr = Image < graythresh(Image)*255;

%plot 
subplot(2,2,2);
imshow(ImageThr, [0 1]);
title('Threshold');

%define the structure element
StrucElem = strel('disk', 4);

%do a closure
ImageClose = imclose(ImageThr, StrucElem);

%plot 
subplot(2,2,3);
imshow(ImageClose);
title('Closure');

StrucElem = strel('disk', 15);
%do erosions
ImageErode = imerode(ImageClose, StrucElem);
%plot 
subplot(2,2,4);
imshow(ImageErode);
title('Erosion');

%show how spheres can be counted
%connected component labeling 
[LabelImage, NumberLabels] = bwlabel(ImageErode);


%use jet colormap with entry 1 equal 0
figure(2); 
imshow(mat2gray(LabelImage), 'colormap', Cmap); 
title(strcat('Number of objects: ',int2str(NumberLabels)));

%create an image with the original spheres and the centroids as overlay 
%(a circle indicating the radius can be added)
