close all; clear all; clc;


Img = imread('./Images/Image_012.png');

% Define options
dx = [-1 0 1 ; -1 0 1 ; -1 0 1]; dy = dx';
Th_deriv = 12;		% 

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

% Because matlab can't show angle correct under linux
%figure(2);
%figure(3);



A.Angle;

