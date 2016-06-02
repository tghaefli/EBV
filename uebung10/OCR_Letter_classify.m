clear all;  close all;

Letter = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
ClassVectors = load('./OCR_Train/ClassVectors_Letter.dat');

%track total number of errors (works only if letters are in aphabetic
%order)
TotError = 0;
%define a minimum and maximum height of the bounding box 
MinHeigth = 15;
MaxHeigth = 50;
%number of angle bins (4 or 8)
AngleBins = 8;
AngleDiv = 4;

LimitDf = 30;

for Index = 1:8
    %read image
    Image = imread(strcat('.\OCR_Train\OCR_Letter', sprintf('%02d', Index), '.png'));
    if size(Image,3) == 3
        Image = rgb2gray(Image);
    end

    %plot the image
    figure(Index);
    imshow(Image);
    title('Original');

    %binarize
    ImageThresh = Image < 230;%use a fixed threshold for the artificial images
    
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
    for Number=1:size(Prop,1) 
        BBox = Prop(Number).BoundingBox;
        if BBox(4) > MinHeigth && BBox(4) < MaxHeigth %witdth of letter 'I' is very small
            rectangle('Position', BBox, 'EdgeColor',[1 0 0]);            
            %increment number of letters
            NumLetters = NumLetters+1;
        end
    end

    IndexChar = 1;
    %loop over the characters    
    for Number = 1:size(Prop,1)  
        %x,y,dx,dy
        BBox = Prop(Number).BoundingBox;
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

			%determine the difference
        	Help = (ClassVectors-ones(size(ClassVectors,1),1)*FeatureVec);
        	Diffs = sqrt(sum(Help.*Help,2));%default is Euclidean Norm                 

            [Val, Ind] = min(Diffs);
            if Ind == IndexChar
                text(BBox(1)+BBox(3)/2, BBox(2)+BBox(4)+10, Letter(Ind));
            else 
                TotError = TotError+1;
                text(BBox(1)+BBox(3)/2, BBox(2)+BBox(4)+10, Letter(Ind), 'color', [1 0 0]);
            end
            IndexChar = IndexChar+1;
        else
            %text(BBox(1)+BBox(3)/2, BBox(2)+BBox(4)+10, 'o');
        end
    end
end

display(TotError)
