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
Img_Skelet = uint8(bwmorph(Img_Skelet, 'thin', Inf));	


% ************************ ANGLE ************************
Img_dx_Skel = imfilter(Img_Skelet, opt.dx);
Img_dy_Skel = imfilter(Img_Skelet, opt.dy);


Img_Angle = atan2(double(Img_dy_Skel), double(Img_dx_Skel));	% atan2 can't work with binary


ctr_0 = 0;
ctr_45 = 0;
ctr_90 = 0;
ctr_135 = 0;

[sx sy] = size(Img);

for n=1:sx
	for m=1:sy

		if(Img_Angle(n,m) < 0.1)

		elseif(Img_Angle(n,m) < 22.5*pi/180)
			ctr_0 = ctr_0+1;
		elseif (Img_Angle(n,m) < 67.5*pi/180)
			ctr_45 = ctr_45+1;
		elseif (Img_Angle(n,m) < 112.5*pi/180)
			ctr_90 = ctr_90+1;
		elseif (Img_Angle(n,m) < 157.5*pi/180)
			ctr_135 = ctr_135+1;
		elseif (Img_Angle(n,m) < 180*pi/180)
			ctr_0 = ctr_0+1;
		else
			disp('ERROR!!!');
		end

	end	%m
end	%n

[max index] = max([ctr_0 ; ctr_45 ; ctr_90 ; ctr_135]);

if(index == 1)
	Angle = 0;
elseif(index == 2)
	Angle = 45
elseif(index == 3)
	Angle = 90;
elseif(index == 4)
	Angle = 135;
end


% *******************************************************

A = struct('Img_Grad',Img_Grad, ...
			'Img_Morph',Img_Morph, ...
			'Img_Skelet',Img_Skelet, ...
			'Img_Angle',Img_Angle, ...
			'Angle',Angle);

end