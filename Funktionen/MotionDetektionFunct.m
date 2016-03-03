function [ThreshImage, DiffImage] = MotionDetektionFunct(ImageAct, ImageOld)

global Threshold

%this is the threshold value (chosen manually)
Threshold = 15;

%calcuate difference image
%DiffImage = uint8(double(ImageAct)-double(ImageOld)+double(128));


DiffImage = 0.5*(double(ImageAct)-double(ImageOld)+255);
DiffImage = uint8(DiffImage);


%calculate the threshold image
ThreshImage = uint8(abs(DiffImage-128) > Threshold);

    
