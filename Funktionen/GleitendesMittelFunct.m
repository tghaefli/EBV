function [ThreshImage, DiffImage, BackGround] = GleitendesMittelFunct(ImageAct, BackGround, Params)

%calcuate forground estimate
DiffImage = abs(double(ImageAct) - double(BackGround));

%estimate new background as sliding average
% If Diff-Image too much, don't include that pixel in background!
BackGround = Params.AvgFactor*BackGround + ...
                (1-Params.AvgFactor)*ImageAct;
    
%calculate the threshold image
ThreshImage = DiffImage > Params.Threshold;
%ThreshImage = uint8(abs(DiffImage-128) > Params.Threshold);

    
