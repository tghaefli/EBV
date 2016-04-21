clear all;  close all;  clc;

%we create a simple synthetic image
Image = uint8(zeros(13,12));

%object 1
Image(2,10:11) = 255;
Image(3,9:11) = 255;
Image(4,8:10) = 255;
Image(5,7:9) = 255;
Image(6,7:8) = 255;

%object 2
Image(7,2) = 255;
Image(7,4:5) = 255;
Image(8,2) = 255;
Image(8,4:5) = 255;
Image(9,2:5) = 255;
Image(10,2:5) = 255;

%object 3
Image(9,9:11) = 255;
Image(10,9) = 255;
Image(10,11) = 255;
Image(11,9) = 255;
Image(11,11) = 255;
Image(12,9:11) = 255;

%plot it
figure(1)
subplot(2,3,1)
imshow(Image)

%do labeling (use 8 neighbors, the default)
[LabelImage, NumberLabels] = bwlabel(Image);

%do feature extraction 
Prop = regionprops(LabelImage,'Area','Centroid','ConvexHull', 'Orientation');
%the result is the structure array Prop, with NumLabels x 1 entries 

%plot the result
subplot(2,3,2)
imshow(LabelImage, []);

for Ind=1:size(Prop,1) 
    Cent=Prop(Ind).Centroid;
    Area=Prop(Ind).Area;
    X=Cent(1);Y=Cent(2);
    text(X-1,Y+2, sprintf('area = %d', Area), 'BackgroundColor',[.8 .8 .8]);        
end
title('area');

subplot(2,3,3)
imshow(LabelImage, []);
%plot center of mass using a cross (line) or a rectangle
for Ind=1:size(Prop,1)
    X=Prop(Ind).Centroid(1)
    Y=Prop(Ind).Centroid(2)
    line([X-1 X+1],[Y-1 Y+1], 'LineWidth',1,'Color',[0 1 0])
    line([X+1 X-1],[Y-1 Y+1], 'LineWidth',1,'Color',[0 1 0])
end
title('center of mass');

subplot(2,3,4)
imshow(LabelImage, []);
%plot convex hull using line
for Ind=1:size(Prop,1)
    [k tmp] = size(Prop(Ind).ConvexHull);
    k = k-1;
    
    for n=1:k
        x = Prop(Ind).ConvexHull(n,1)
        x2 = Prop(Ind).ConvexHull(n+1,1)

        y = Prop(Ind).ConvexHull(n,2)
        y2 = Prop(Ind).ConvexHull(n+1,2)

        line([x x2],[y y2],'LineWidth',2,'Color',[0 1 0]);
    end
end


title('convex hull');



subplot(2,3,5)
imshow(LabelImage, []);
%draw a line through the centroid with given orientation
for Ind=1:size(Prop,1)
    X_center = Prop(Ind).Centroid(1)
    Y_center = Prop(Ind).Centroid(2)
    Angle = Prop(Ind).Orientation;
    line([X_center-2*cos(Angle/180*pi) X_center+2*cos(Angle/180*pi)], ...
        [Y_center+2*sin(Angle/180*pi) Y_center-2*sin(Angle/180*pi)], ...
        'LineWidth',2,'Color',[0 1 0])
end
title('orientation');

subplot(2,3,6)
imshow(LabelImage, []);
%construct the bounding box using line or rectangle
for Ind=1:size(Prop,1)
    X_min=min(Prop(Ind).ConvexHull(:,1))
    X_max=max(Prop(Ind).ConvexHull(:,1))
    Y_min=min(Prop(Ind).ConvexHull(:,2))
    Y_max=max(Prop(Ind).ConvexHull(:,2))
    
    line([X_min X_min+1E-10],[Y_min Y_max], 'LineWidth',1,'Color',[0 1 0])
    line([X_max X_max+1E-10],[Y_min Y_max], 'LineWidth',1,'Color',[0 1 0])
    line([X_min X_max],[Y_min Y_min+1E-10], 'LineWidth',1,'Color',[0 1 0])
    line([X_min X_max],[Y_max Y_max+1E-10], 'LineWidth',1,'Color',[0 1 0])
end
title('bounding box');
