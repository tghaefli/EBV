clear all;  close all;  clc;



%           
%   y_low   ________________
%           |       |       |
%   y_med   |_______|_______|
%           |       |       |
%   y_up    |_______|_______|
%           |       |       |
%   x_low   |_______|_______|  
%                 x_up    
%
%


%we have a rows of 26 numbers in the image
NumEntries = 26;
Letter = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ......';
%map used for pseudo colors
Cmap=colormap(hsv);
Cmap(1,:) = 0;

%used to store overall feature vector data
FeatureVecTot = [];

%define a minimum and maximum height of the bounding box 
MinHeigth = 15;
MaxHeigth = 50;

%number of angle bins (4 or 8)
AngleBins = 8;
LimitDf = 30;

ClassVectors = zeros(NumEntries,AngleBins*6);%AngleBins directions with 6 sectors 

for Index = 1:8     % Interate trough all fonts
    %read image
    Image = imread(strcat('./OCR_Train/OCR_Letter', sprintf('%02d', Index), '.png'));
    if size(Image,3) == 3
        Image = rgb2gray(Image);
    end

    %plot the image
    figure(Index);
    subplot(3,1,1);
    imshow(Image);
    title('Original');

    %binarize
    ImageThresh = Image < 230;%use a fixed threshold for the artificial images
    
    %plot it 
    figure(Index);subplot(3,1,2)
    imshow(ImageThresh, []);
    title('Threshold');
    
    %calculate the derivative
    DX = -fspecial('sobel')';%sign convention!!
    DY = -fspecial('sobel');%sign convention!!
    %calculate the gradient
    %apply the DX and DY filter
    ActImageDx = imfilter(double(Image), DX);
    ActImageDy = imfilter(double(Image), DY);

    %calculate the norm of the derviative
    ActImageDr = sqrt(ActImageDx.*ActImageDx+ActImageDy.*ActImageDy);
    %determine the angle (atan2 gives back the whole interval ]-pi , pi[ )
    Angle = pi+atan2(ActImageDy, ActImageDx);
     %for checking of angle intervals
    % xw=[0:0.1:2*pi]; plot(AngleBins*xw/(2*pi),1+mod(round(xw/(2*pi/AngleBins)), AngleBins),'bo-')

    %we map the angle intervall to AngleBins equally spaced bins
    Angle = 1+mod(round(Angle/(2*pi/AngleBins)), AngleBins);
   
    %mask out the smaller values
    Angle(ActImageDr < LimitDf) = 0;
    
    %determine the connected components and plot boxes
    [LabelImage, NumberLabels] = bwlabel(ImageThresh);
    Prop = regionprops(LabelImage,'Area','BoundingBox');
    hold on;
    NumLetters = 0;
    ChosenIndex = [];
    for Number=1:size(Prop,1) 
        BBox = Prop(Number).BoundingBox;
        if BBox(4) > MinHeigth && BBox(4) < MaxHeigth %witdth of letter 'I' is very small
            rectangle('Position', BBox, 'EdgeColor',[1 0 0]);            
            %increment number of letters
            NumLetters = NumLetters+1;
            ChosenIndex = [ChosenIndex, Number];%lookup for correct index (we may skip objects that are too small)
            text(BBox(1), BBox(2)+BBox(4)+30, Letter(NumLetters), 'Color',[1 0 0]);
        end
    end

    %we require
    if NumLetters ~= NumEntries
        strcat('we could not get ', mat2str(NumEntries),' letters by closure operation!' );
        % STOP %dummy code that stops execution
    end

    figure(Index);subplot(3,1,3)
    imshow(Angle, [0 AngleBins]);
    title('Angle');
    %set color map
    colormap(Cmap);
    %feeze it and ...
    freezeColors;  
    %set back color map (this is the only way it seems to work with b/w plots)
    colormap('Gray(255)');

    %loop over the characters    
    for Number = 1:NumEntries 
        %x,y,dx,dy
        BBox = Prop(ChosenIndex(Number)).BoundingBox;
        %check for minimum size
        if BBox(4) > MinHeigth && BBox(4) < MaxHeigth        
            %we cut the box in 3x2 pieces (BBox is calculated to 0.5
            %pixels, thus upper-left is ceil(BBox(2), BBox(1))
            %x-indices
            Xlo = [ceil(BBox(1)):round(BBox(1)+BBox(3)/2)];
            Xup = [round(BBox(1)+BBox(3)/2)+1:floor(BBox(1)+BBox(3))];        
            %y-indices
            Ylo = [ceil(BBox(2)):round(BBox(2)+BBox(4)/3)];
            Ymi = [round(BBox(2)+BBox(4)/3)+1:round(BBox(2)+BBox(4)*2/3)];
            Yup = [round(BBox(2)+BBox(4)*2/3)+1:floor(BBox(2)+BBox(4))];
            %collect the data
            Sector = Angle(Ylo, Xlo);
            FeatureVec = sum(Sector(:)*ones(1,AngleBins) == ones(size(Sector(:)))*[1:AngleBins]);
            Sector = Angle(Ylo, Xup);
            FeatureVec = [FeatureVec, sum(Sector(:)*ones(1,AngleBins) == ones(size(Sector(:)))*[1:AngleBins])];
            Sector = Angle(Ymi, Xlo);
            FeatureVec = [FeatureVec, sum(Sector(:)*ones(1,AngleBins) == ones(size(Sector(:)))*[1:AngleBins])];
            Sector = Angle(Ymi, Xup);
            FeatureVec = [FeatureVec, sum(Sector(:)*ones(1,AngleBins) == ones(size(Sector(:)))*[1:AngleBins])];
            Sector = Angle(Yup, Xlo);
            FeatureVec = [FeatureVec, sum(Sector(:)*ones(1,AngleBins) == ones(size(Sector(:)))*[1:AngleBins])];
            Sector = Angle(Yup, Xup);
            FeatureVec = [FeatureVec, sum(Sector(:)*ones(1,AngleBins) == ones(size(Sector(:)))*[1:AngleBins])];

            %normalize feature vector
            FeatureVec = FeatureVec/sum(FeatureVec);  
            
            %save the individual feature vectors
            FeatureVecTot = [FeatureVecTot; Index, Number, FeatureVec];
            
            ClassVectors(Number,:) = ClassVectors(Number,:)+FeatureVec;   
        end
    end
end
%we normalize to number of rows
ClassVectors = ClassVectors./(sum(ClassVectors,2)*ones(1,size(ClassVectors,2)));
save('.\OCR_Train\ClassVectors_Letter.dat', 'ClassVectors', '-ascii');
save('.\OCR_Train\FeatureVecTot.dat', 'FeatureVecTot', '-ascii');

%write out as c-header file
fileID = fopen('FeatureVectors.h','w');
fprintf(fileID, '#define NumFeatures 48\r\n');
fprintf(fileID, '#define NumChars 26\r\n');
fprintf(fileID, '\r\n');
fprintf(fileID, 'double FeatureVector[NumChars][NumFeatures]={\r\n');
for i1 = 1:size(ClassVectors,1)
    fprintf(fileID, '{');    
    for i2 = 1:size(ClassVectors,2)
        if i2 < size(ClassVectors,2)
            fprintf(fileID, ' %u,', ClassVectors(i1,i2));
        else
            fprintf(fileID, ' %u', ClassVectors(i1,i2));
        end
    end
    if i1 < size(ClassVectors,1)
        fprintf(fileID, '},\r\n'); 
    else
        fprintf(fileID, '}\r\n');
    end
end
fprintf(fileID, '};');  
fclose(fileID);

figure(Index+1);
surf(ClassVectors);
xlabel('feature index (1-48)');
ylabel('letter index (A-Z)');
zlabel('probability');
title('class vectors');


