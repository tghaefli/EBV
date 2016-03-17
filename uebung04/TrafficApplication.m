clear 'all';
close 'all';

%path were pictures are stored
Path = '..\uebung02\Autobahn\img_';
%this is the delta of the step
Delta = 1;

%parameter structure
Params = struct();
Params.AvgFactor = 0.95;%the average factor determines the speed of adaptation 
Params.Threshold = 8;%this is the threshold value (chosen manually)
Params.MaxFgr = 200;%this is maximum number of steps a pixel is in the foreground

%read first image to index 0
Index = 0;
FileName = strcat(Path, sprintf('%04d', Index), '.bmp');
%BackGround = imread(FileName);
%you can also read the last image of the treatment, which was saved before
BackGround = imread('Background.png');

%individual counter for each pixel to keep track of number of step in the
%foreground
FgrCnt = zeros(size(BackGround));
%we do everything in double (easier)
BackGround = double(BackGround);

%loop over required range, with step size Delta
for Index = Delta:Delta:400
    %read next image
    FileName = strcat(Path, sprintf('%04d', Index), '.bmp');
    ImageAct = imread(FileName);
    
    %call the function
    [ThreshImage, DiffImage, BackGround, FgrCnt] = GleitendesMittelFunct(double(ImageAct), BackGround, FgrCnt, Params); 
    
    %plot current image
    figure(1);subplot(2,3,1);
    imshow(ImageAct);
    title('acutal image');
    
    %plot difference image
    subplot(2,3,2);
    imshow(BackGround, []);
    title('background image');
    
    %plot the threshold image
    subplot(2,3,3);
    imshow(ThreshImage, []);
    title('image changes');
    
	ThreshImageOpen = imopen(ThreshImage, ones(3));
    %plot raw foreground image after opening
    subplot(2,3,4);
    imshow(ThreshImageOpen,[]);
    title('opening of foreground');
    
	ThreshImageClose = imclose(ThreshImageOpen, ones(5));
    %plot raw foreground image after opening and closure
    subplot(2,3,5);
    imshow(ThreshImageClose, []);
    title('opening and closure of foreground');
    
end

%save the background image at the end
imwrite(uint8(BackGround), 'Background.png');