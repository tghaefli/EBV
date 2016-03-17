function A = angle_detection(Img, opt)


% *********************** GRADIENT ***********************
Img_dx = imfilter(Img, opt.dx);
Img_dy = imfilter(Img, opt.dy);

Img_dx_th = (Img_dx > opt.Th_deriv);	% Background must be black!
Img_dy_th = (Img_dy > opt.Th_deriv);

Img_Grad = (Img_dx_th.^2 + Img_dy_th.^2).^0.5;


% ********************** MORPHOLOGIE **********************
N = opt.size_Morph;
Img_Morph = ordfilt2(Img_Grad, round(N^2/2), ones(N,N)); 


% *********************** SKELETON ***********************
%requires binary image
Img_Skelet = (Img_Morph > 0);					% Generate binary picture
Img_Skelet = bwmorph(Img_Skelet, 'thin', Inf);


% ************************ ANGLE ************************
Img_Angle = Img;


Angle = 0;




% *******************************************************

A = struct('Img_Grad',Img_Grad, ...
			'Img_Morph',Img_Morph, ...
			'Img_Skelet',Img_Skelet, ...
			'Img_Angle',Img_Angle, ...
			'Angle',Angle);

end