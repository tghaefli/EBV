% @file:        b2.m
% @date:        2016-07-01 (yyyy-mm-dd)
% @author:      Pascal Häfliger
%
% @description: "Proof of Concept"
%

close all;  clear all;  clc;

Path  = './images_color/image';
Delta = 1;


%parameter structure
Params = struct();
Params.AvgFactor = 0.8;%the average factor determines the speed of adaptation 
Params.Threshold = 15;%this is the threshold value (chosen manually)
Params.MaxFgr = 200;%this is maximum number of steps a pixel is in the foreground


BackGround = imread('./images_color/image0000.png');
FgrCnt = zeros(size(BackGround));
%BackGround = double(BackGround);

for Index = 1:Delta:148
    FileName = strcat(Path, sprintf('%04d', Index), '.png');
    ImageAct = imread(FileName);
    %imshow(ImageAct);
    
    % Da sehr starke beleuchtung --> ycbcr und die Helligkeit weglassen
    % Change Detection muss dadurch nicht abgeändert werden und man muss
    % das Bild nur 2x, nicht 3x überprüfen mit der Changedetection
    Img_Act_YCbCr = rgb2ycbcr(ImageAct);
    Img_Bkg_YCbCb = rgb2ycbcr(BackGround);
    
    Img_Act_Y = Img_Act_YCbCr(:,:,1);    Img_Act_Cb = Img_Act_YCbCr(:,:,2);    Img_Act_Cr = Img_Act_YCbCr(:,:,3);
    Img_Bkg_Y = Img_Bkg_YCbCb(:,:,1);    Img_Bkg_Cb = Img_Bkg_YCbCb(:,:,2);    Img_Bkg_Cr = Img_Bkg_YCbCb(:,:,3);

    
    % Method nicht erweitert, jedoch die Parameter angepasst
    [ThreshImage_Cb, DiffImage_Cb, BackGround_Cb] = GleitendesMittelFunct(double(Img_Act_Cb), double(Img_Bkg_Cb), FgrCnt, Params);
    [ThreshImage_Cr, DiffImage_Cr, BackGround_Cr] = GleitendesMittelFunct(double(Img_Act_Cr), double(Img_Bkg_Cr), FgrCnt, Params);

    figure(1)
    imshow(DiffImage_Cb, []);    
    figure(2)
    imshow(DiffImage_Cr, []);

      
    
    
    % Rauschen eliminieren und Fahrzeuge schliessen
    size_str_element = 8;
    ThreshImage = imerode(ThreshImage, strel('disk',size_str_element));
    ThreshImage = imdilate(ThreshImage, strel('disk',size_str_element*2));    
    
    
%     %plot current image
%     figure(1);subplot(2,2,1);
%     imshow(ImageAct, [0 255]);    
%     title(sprintf('currently image %d', Index));
%     
%     %plot background image
%     subplot(2,2,2);
%     imshow(BackGround, [0 255]);
%     title('background image');
%     
%     %plot the histogram of the diff image
%     subplot(2,2,3);
%     imshow(DiffImage, [0 255]);
%     title('difference image');
%     
%     %plot the threshold image
%     subplot(2,2,4);
%     imshow(ThreshImage, [0 1]);
%     ImgTitle = strcat('foreground image');
%     title(ImgTitle);

    figure(1);
    imshow(ImageAct);
    title(sprintf('currently image %d', Index));

    obj_ctr=0;
    Prop = regionprops(ThreshImage,'Area','Centroid','BoundingBox');
    for Ind=1:numel(Prop)
        if Prop(Ind).Area > 10000
            obj_ctr=obj_ctr+1;

            Cent=Prop(Ind).Centroid;
            X=Cent(1);Y=Cent(2);
            %line([X-10 X+10],[Y Y]);
            %line([X X],[Y-10 Y+10]);

            Box=Prop(Ind).BoundingBox;
            rectangle('Position',Box, 'EdgeColor', [0 1 0], 'LineWidth', 3);
               
            my_title = strcat('Length: ', sprintf('%04d', Box(3)),'pixel');
            text(X,Y-10,sprintf(my_title),'BackgroundColor',[.8 .8 .8]); 
            
            
            % BoundingBox über das OriginalBild legen
            % ImageAct(~BoundingBox)=0
        end
        
        % there is ALWAYS an object (car, moto, ...), so we force to find it.
        % Mit besserer Hintergrundschätzung wäre dieser workaround nicht
        % nötig
        while obj_ctr==0 
            Cent=Prop(Ind).Centroid;
            X=Cent(1);Y=Cent(2);
            
            Box=Prop(Ind).BoundingBox;
            rectangle('Position',Box, 'EdgeColor', [0 1 0], 'LineWidth', 3);
            
            my_title = strcat('Length: ', sprintf('%04d', Box(3)),'pixel');
            text(X,Y-10,sprintf(my_title),'BackgroundColor',[.8 .8 .8]);            
            
            obj_ctr=obj_ctr+1;
            
        end
    end
  
    
    drawnow();
    pause(0.05);

end