close all; clear all; clc;


Img = double(imread('./Images/Image_001.png'));	% We work with double !!!

% Define options
dx = [-1 0 1 ; -1 0 1 ; -1 0 1]; dy = dx';		% Prewitt
%dx = [-1 0 1 ; -2 0 2 ; -1 0 1]; dy = dx';		% Sobbel

Th_deriv = 12;	

size_Morph = 5;


options = struct('dx',dx, 'dy',dy, ...
          		 'Th_deriv', Th_deriv, ...
          		 'size_Morph', size_Morph);



% Run script / function
A = angle_detection(Img, options);



% ************************ ORIGINAL ************************
figure(1);
subplot(2,2,1);
imshow(Img, []);
title('Original');


% ************************ GRADIENT ************************
subplot(2,2,2);
imshow(A.Img_Grad, []);
title('Gradient');


% ************************ MORPHOLOGIE ************************
subplot(2,2,3);
imshow(A.Img_Morph, []);
title('Morph');


% ************************ SKELETON ************************
subplot(2,2,4);
title('Skeleton');
imshow(A.Img_Skelet, []);
title('Skeleton');


% ************************ ANGLE ************************
A.Angle

figure(2)
imshow(A.Img_Angle, []);
map=colormap(jet);
map(1,:) = 0;
colormap(map)
colorbar;

title(strcat('Current Angle: ',num2str(A.Angle),'°'));


