 
%perform thinning with various structuring elements
function [RetImage] = DoThinning(Image)




NumElem = 1;%define 8 structuring elements for thinning
StrucElem = zeros(3,3,NumElem);
%the main elements
SE1 = [-1 -1 0; -1 1 1; 0 1 0];


StrucElem(:,:,1) = SE1;

    
RetImage = Image > 0;
for Ind = 1:NumElem
    %apply hit miss operation
    HMImage = bwhitmiss(RetImage,StrucElem(:,:,Ind));
    % figure(5);
    % imshow(HMImage, [0 1]);
    %set the resuls of hit miss to 0
    RetImage(HMImage ~= 0) = 0;
    % figure(6);
    % imshow(RetImage, [0 1]);
end

end