function [ThreshImage, DiffImage, BackGround, FgrCnt] = GleitendesMittelFunct(ImageAct, BackGround, FgrCnt, Params)


%calcuate difference image (scale back to [0 255])
DiffImage = (255+(BackGround - ImageAct))/2;
%now calculate the threshold image (foreground estimate)
% this is a boolean image and can be used for indexing
ThreshImage = abs(DiffImage-128) > Params.Threshold; 

%estimate new background as sliding average (but only on inverse of
%ThreshImage
BackGround(~ThreshImage) = Params.AvgFactor*BackGround(~ThreshImage)+(1-Params.AvgFactor)*ImageAct(~ThreshImage);  %imlincomb()

%now upate the foreground counter
FgrCnt(ThreshImage) = FgrCnt(ThreshImage)+1;
FgrCnt(~ThreshImage) = max(0, FgrCnt(~ThreshImage)-1);
    
%we reset pixel that are too long in the foreground
BackGround(FgrCnt > Params.MaxFgr) = ImageAct(FgrCnt > Params.MaxFgr);
FgrCnt(FgrCnt > Params.MaxFgr) = 0;

    
