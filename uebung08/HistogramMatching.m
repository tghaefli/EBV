function [CorrImage, MaxPosition] = HistogramMatching(Image, Template, Bins, Increment)
%histogramMatching Find the positions of the template in the image by
%comparing the histogram of the template and the histogram at the possible
%image location

% calculate the histogram of the template
TemplateHist = Farbhist(Template, Bins);

% compare at all positions
[TemplateHeight, TemplateWidth, ColorP] = size(Template);
[ImageHeight, ImageWidth, ColorP] = size(Image);
%we calculate with the total image but do a subsampling of increment
CorrImage = zeros(length(1:Increment:ImageHeight-TemplateHeight), length(1:Increment:ImageWidth-TemplateWidth));

SubImg = uint8(zeros(size(Template)));
%loop over Rows
Rsub = 1;
for Rows = 1:Increment:ImageHeight-TemplateHeight 
    %display the progress (rather slow :-|
    disp(Rows)
    %loop over cols
    Csub = 1;
	for Cols = 1:Increment:ImageWidth-TemplateWidth        
        % extract distance value using DistFunction(hist1, hist2);
        % where hist1 is the template histogram and hist2 is the histogram
        % at the current image position (Rows, Cols) having the same size
        % as the template hist
        CorrImage(Rsub, Csub) = 0;%%% ?????????????? 
        Csub = Csub+1;
    end
    Rsub = Rsub+1;
end

% find the maximum position in the output
% find the maxima for each column (the index gives the row for each column)
[MaxValCol, MaxRowIndex] = max(CorrImage, [], 1);
%find the maximum over all columns
[MaxValue, MaxColIndex] = max(MaxValCol);
%return the max position
MaxPosition = [MaxRowIndex(MaxColIndex), MaxColIndex]*Increment;
end


