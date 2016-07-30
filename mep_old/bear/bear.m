%Not a MEP!!! 
clear all; close all; clc;

Image = (imread('gummibaer.jpg'));
Image_D = double(Image);
Image_I = uint8(Image);
figure(1)
imshow(Image);


Red = Image_D(:,:,1);
Green = Image_D(:,:,2);
Blue = Image_D(:,:,3);

ThrCol = [140 140 100];
LimitVal = 130;


IndexImg = (Red-ThrCol(1)).^2 + (Green-ThrCol(2)).^2 + (Blue-ThrCol(3)).^2 < LimitVal.^2;

imbkgcopen = imopen(~IndexImg,strel('disk',20));
imbkgclose = imclose(imbkgcopen,strel('disk',20));
imbkgclose = ~imbkgclose;

%%
figure(4);
imshow(imbkgclose);
title('Baers without Background');


props = regionprops(imbkgclose,'Centroid','BoundingBox','Area');
title('Masspoint and Boundingbox');

for ind = 1:length(props)
    if props(ind).Area > 10000
        center = props(ind).Centroid;
        line([center(1)-7 center(1)+7], [center(2) center(2)],'LineWidth',1,'Color',[0 0 0]);
        line([center(1) center(1)], [center(2)-7 center(2)+7],'LineWidth',1,'Color',[0 0 0]);
        rectangle('position',props(ind).BoundingBox, 'EdgeColor', 'green');
    end
end



for ind = 1:length(props)
    if props(ind).Area > 10000
        center = props(ind).Centroid;

        ctr_red=sum(sum(...
            Red(round(center(2))-5:round(center(2))+5,...
                round(center(1))-5:round(center(1))+5)
        ));

        ctr_green=sum(sum(...
            Green(round(center(2))-5:round(center(2))+5,...
                round(center(1))-5:round(center(1))+5)
        ));

        ctr_blue=sum(sum(...
            Blue(round(center(2))-5:round(center(2))+5,...
                round(center(1))-5:round(center(1))+5)
        ));

        [ctr_red ctr_green ctr_blue]

        if(ctr_red-2e4 > ctr_blue || ctr_red-2e4 > ctr_green)  %red = green --> yelllow
            disp('red')
        end



        

    end
end