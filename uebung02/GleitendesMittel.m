clear 'all';
close 'all';

%path were pictures are stored
Path = 'img_';

%this is the delta of the step
Delta = 1;

%parameter structure
Params = struct();
Params.AvgFactor = 0.95;%the average factor determines the speed of adaptation 
Params.Threshold = 30;%this is the threshold value (chosen manually)

%read first image to index 0
Index = 0;
FileName = strcat(Path, sprintf('%04d', Index), '.bmp');
BackGround = imread(FileName);

%loop over required range, with step size Delta
for Index = Delta:Delta:200
    %read next image
    FileName = strcat(Path, sprintf('%04d', Index), '.bmp');
    ImageAct = imread(FileName);
    
    %call the function
    [ThreshImage, DiffImage, BackGround] = GleitendesMittelFunct(ImageAct, BackGround, Params);
    
    %plot current image
    figure(1);subplot(2,2,1);
    imshow(ImageAct, [0 255]);    
    title(sprintf('currently image %d', Index));
    
    %plot background image
    subplot(2,2,2);
    imshow(BackGround, [0 255]);
    title('background image');
    
    %plot the histogram of the diff image
    subplot(2,2,3);
    imshow(DiffImage, [0 255]);
    title('difference image');
    
    %plot the threshold image
    subplot(2,2,4);
    imshow(ThreshImage, [0 1]);
    ImgTitle = strcat('foreground image');
    title(ImgTitle);
    
    %pause(0.00001);
    drawnow();
end

%save the background image at the end
imwrite(uint8(BackGround), 'Background.png','png');