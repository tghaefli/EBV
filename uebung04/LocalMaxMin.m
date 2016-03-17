clear 'all';
close 'all';


%%%%%%%%%%%%%% image creation %%%%%%%%%%%%%%%%
%size of image
Sx = 300;
Sy = 400;
%number of desired points
NumPoi = 100;
%create emtpy image
Image = zeros(Sy, Sx);
%create NumPoin random indices between 1 and Sx*Sy
Indices = 1+floor((Sx*Sy-1)*rand(1, NumPoi));
%set them to one
Image(Indices) = 1;
%create 'valley' and 'hill' image using distance image
ImgValley = bwdist(Image);
ImgHill = max(0, max(ImgValley(:))-ImgValley);
%normalize them
ImgValley = uint8(255*ImgValley/max(ImgValley(:)));
ImgHill = uint8(255*ImgHill/max(ImgHill(:)));
%%%%%%%%%%%% end image creation %%%%%%%%%%%%%


%use a real image
% ImgValley = imread('..\uebung01\London.png');
% ImgHill = ImgValley;

%size of region of local min/max detection 
%equal values are nevertheless deteted!!
SizeRegion = 10;

%plot the images
figure(1);
subplot(1,2,1);
imshow(ImgValley);
title('Image with "valleys"');
subplot(1,2,2);
imshow(ImgHill);
title('Image with "hills"');

%apply min/max filter ????????????????
MinVal = ImgValley;
MaxVal = ImgHill;

%find local min/max values ?????????????????????
LocMin = (MinVal == 100);
LocMax = (MaxVal == 200);

%plot everything
figure(2);
subplot(1,2,1);
imshow(ImgValley);
title('local minima');

%plot min values
[Rows, Cols] = find(LocMin);
for i1 = 1:length(Rows)
   BBox = [Cols(i1)-5 Rows(i1)-5 10 10];
   rectangle('Position', BBox, 'EdgeColor',[1 0 0], 'Curvature',[1,1]);     
end

subplot(1,2,2);
imshow(ImgHill);
title('local maxima');

%plot max values
[Rows, Cols] = find(LocMax);
for i1 = 1:length(Rows)
   BBox = [Cols(i1)-5 Rows(i1)-5 10 10];
   rectangle('Position', BBox, 'EdgeColor',[1 0 0], 'Curvature',[1,1]);     
end
