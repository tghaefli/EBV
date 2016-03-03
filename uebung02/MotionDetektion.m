clear 'all';
close 'all';

global Threshold

%path were pictures are stored
Path = 'img_';
%path where image with large changes should be stored
ChangePath = 'Changes_img_';
%counter for image saved
SaveIndex = 0;

%this is the delta of the step
Delta = 2;

%read first image to index 0
Index = 0;
FileName = strcat(Path, sprintf('%04d', Index), '.bmp');
ImageOld = imread(FileName);


%loop over required range, with step size Delta
for Index = Delta:Delta:400
    %read next image
    FileName = strcat(Path, sprintf('%04d', Index), '.bmp');
    ImageAct = imread(FileName);
    
    %call function
    [ThreshImage, DiffImage] = MotionDetektionFunct(ImageAct, ImageOld);    
   
    %plot current image
    figure(1);subplot(2,2,1);
    imshow(ImageAct);
    title('current image');
    
    %plot difference image
    subplot(2,2,2);
    imshow(DiffImage);
    title('difference image');
    
    %plot the histogram of the diff image
    subplot(2,2,3);
    [Hist, Val] = imhist(DiffImage);
    plot(Val, log(max(1,Hist)), 'bo-');
    title('histogram of difference image');
    xlabel('gray values');
    ylabel('log(hist)');
    figure(1);
    
    %plot the threshold image
    subplot(2,2,4);
    imshow(255*ThreshImage);
    ImgTitle = strcat('Image Changes');
    title(ImgTitle);
   
    %set 'new' old image
    ImageOld = ImageAct;
    
    drawnow();
    %pause(0);

end