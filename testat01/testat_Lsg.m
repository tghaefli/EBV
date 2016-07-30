clear 'all';
close 'all';
clc;

Threshold = 25;%adjust threshold 

UseSkelet = 1;%whether to apply skeleton 

Folder = 'Images';
NumFiles = 15;

NumBins = 4;

map=colormap(jet);
map(1,:) = 0;

i0 = 003;
ImageRead = imread(strcat(Folder, '/Image_', sprintf('%03d',i0),'.png'));
%for i0 = 1:NumFiles
%    ImageRead = imread(strcat(Folder, '/Image_', sprintf('%03d',i0),'.png'));
    
    Image = double(ImageRead);

    %plot the image
    figure(1);    
    imshow(Image, [0 255]);
    title('Original');

    %choose the filters
    Sobel = 1;
    if Sobel == 1
        DX = -fspecial('sobel')';%sign convention!!
        DY = DX';	
    else
        DX = -fspecial('prewitt')';%sign convention!!
        DY = DX';    
    end

    %apply the DX and DY filter
    ImageDx = imfilter(Image, DX);
    ImageDy = imfilter(Image, DY);

    %calculate the norm of the derviative (notice the two different version
    %to square a matrice)
    ImageDr = sqrt(ImageDx.*ImageDx+ImageDy.^2);
    ImageThr = ImageDr > Threshold;
    %plot it
    figure(2);
    imshow(uint8(ImageThr), []);
    title('dI/dr');

    StrucElem = strel('square', 3);
    %do opening and closure
    ImageErode = imopen(ImageThr, StrucElem);
    ImageClose = imclose(ImageErode, StrucElem);

    %plot 
    figure(3);
    imshow(uint8(ImageClose));
    title('Morphologie');       

    %determine skeleton
    ImageSkel = bwmorph(ImageClose, 'thin', Inf);
    figure(4);
    imshow(ImageSkel);
    title('Skeleton');       

    %determine the angle (atan2 gives back the whole interval ]-pi , pi[ )
    Angle = atan2(ImageDy, ImageDx);
    Angle(Angle < 0) = pi+Angle(Angle < 0);
    
    %do binning (do not make difference between positive and negative
    %values)
    %test using:
    %NumBins = 6;Angle = [0:0.1:pi];plot(Angle,1+mod(round(Angle/(pi/NumBins)),NumBins),'bo-')
    BinVal = 1+mod(round(Angle/(pi/NumBins)),NumBins);
    
    %use only those values that are above a given threshold (values below threshold are treated as angle zero)
    if UseSkelet == 1
        Angle(~ImageSkel) = 0;
        BinVal(~ImageSkel) = 0;
    else
        Angle(~ImageClose) = 0;
        BinVal(~ImageClose) = 0;
    end   

    AnzVal = [];
    for i1 = 1:NumBins
        AnzVal = [AnzVal, numel(find(BinVal == i1))];
    end
    [maxv, ind] = max(AnzVal);
 
    %plot it
    figure(5)
    imshow(Angle, []);    
    colormap(map)
    title(strcat('angle: ', num2str((ind-1)*45), '�'));
    colorbar;
    
    %wait for one second (chose empty '' to wait till key is hit)
    %pause();
%end