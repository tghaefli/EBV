clear 'all'
close 'all'

%read template
ImageCar = imread('carTest.bmp');
%the number of bins in the color histogram
Bins = 128;
%show the correlation as surface plot
ShowSurf = 1;
%show the histogram of the template
ShowHist = 1;
%defines the increment of calculation
Increment = 10;

if ShowHist ~= 0
    [HistR, Val] = imhist(ImageCar(:,:,1), Bins);
    HistG = imhist(ImageCar(:,:,2), Bins);
    HistB = imhist(ImageCar(:,:,3), Bins);
    figure(15);hold on;
    plot(Val, HistR, 'ro-');
    plot(Val, HistG, 'go-');
    plot(Val, HistB, 'bo-');
    title('color histogram of template')
    xlabel('color value')
    ylabel('absolute frequency')
end


Images = {'1122.jpg', '1344.jpg', '1573.jpg', '1770.jpg', '1428.jpg'}; %the template

for Fig = 1:length(Images)
    Image = imread(char(Images(Fig)));
    %use this line for YCbCr color space; 
    %[CorrImage, MaxPosUpLeft] = HistogramMatching(rgb2ycbcr(Image), rgb2ycbcr(ImageCar), 128, 14);
    [CorrImage, MaxPosUpLeft] = HistogramMatching(Image, ImageCar, Bins, Increment);
    %plot the result
    figure(Fig);
    imshow(Image);
    %shortcut for template size 
    Dy = size(ImageCar,1);
    Dx = size(ImageCar,2);
    %construct the line
    LineVec = [MaxPosUpLeft; MaxPosUpLeft+[0,Dx]; MaxPosUpLeft+[Dy,Dx]; MaxPosUpLeft+[Dy,0]; MaxPosUpLeft];
    %plot it
    line(LineVec(:,2), LineVec(:,1), 'LineWidth', 2);
    text(MaxPosUpLeft(2), MaxPosUpLeft(1)-10, 'Object', 'Color', [1 1 1]);

      
    if ShowSurf ~= 0
        figure(length(Images)+Fig);
        surf([1:Increment:Increment*size(CorrImage,2)], [1:Increment:Increment*size(CorrImage,1)], CorrImage(end:-1:1,:));%plot as surface (have to flip x-values)
        title('correlation image');
        xlabel('x');
        ylabel('y');
        zlabel('arbitrary units')        
    end
    pause();
end