function A = angle_detection(Img, opt)


% *********************** GRADIENT ***********************
if (strcmp(opt.FilterType,'Prewitt'))
    dx = fspecial('prewitt')';
elseif (strcmp(opt.FilterType,'Sobel'))
    dx = fspecial('sobel')';
else
    dx = [1];
end
dy = dx';

Img_dx = imfilter(Img, dx);
Img_dy = imfilter(Img, dy);

Img_Grad = (Img_dx.^2 + Img_dy.^2).^0.5;
Img_Thr = Img_Grad > opt.Th_deriv;


% ********************** MORPHOLOGIE **********************
StrucElem = strel('square', opt.Dim_Morph);
Img_Morph = imopen(Img_Thr, StrucElem);		% Erode
Img_Morph = imclose(Img_Morph, StrucElem);	% Close


% *********************** SKELETON ***********************
Img_Skelet = uint8(bwmorph(Img_Morph, 'thin', Inf));	


% ************************ ANGLE ************************
Img_Angle = atan2(Img_dy, Img_dx);
Img_Angle(Img_Angle < 0) = pi+Img_Angle(Img_Angle < 0);



NumBins = 4;

Img_Angle = Img_Angle/(pi/NumBins);	%[0 4]   or [0 2Pi]
%max(max(Img_Angle))
%min(min(Img_Angle))

BinVal = 1+mod(round(Img_Angle),NumBins);

Img_Angle(~Img_Skelet) = 0;
BinVal(~Img_Skelet) = 0;



AnzVal = [];
for i1 = 1:NumBins
    AnzVal = [AnzVal, numel(find(BinVal == i1))];		% numel = sx * sy ; [sx sy]=size(A)
end														% count all number of elements, where the binvlaue is equal to the current iteration
[maxv, ind] = max(AnzVal);

Angle = (ind-1)*180/NumBins;





% *******************************************************

A = struct(	'Img_Grad'   , uint8(Img_Thr)    , ...
			'Img_Morph'  , uint8(Img_Morph)  , ...
			'Img_Skelet' , uint8(Img_Skelet) , ...
			'Img_Angle'  ,      (Img_Angle)  , ...
			'Angle'      ,      (Angle)      );

end