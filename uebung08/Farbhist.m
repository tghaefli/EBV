
function TemplateHist = Farbhist(Image, Bins)

TemplateHist = [];

for ColorP = 1:size(Image,3)
    Hist = imhist(Image(:,:,ColorP), Bins);
    TemplateHist = [TemplateHist; Hist];
end

end