close all; clear all; clc;

%Img = uint8(imread('./Images/Image_004.png'));
Img = double(imread('./Images/Image_004.png'));

% ************************ OPTIONS ************************
options = struct();
options.FilterType = 'Prewitt';
options.Th_deriv = 15;			% Top    right  picture
options.Dim_Morph = 4;			% Bottom left  picture
options.Closing = 'false';		% Bottom right picture
options.Closing_Dim = 10;		%   --> Imporve skeleton drawing



% ********************* CALL FUNCTION *********************
A = angle_detection(Img, options);


% ************************* PLOTS *************************
figure(1);
subplot(2,2,1);
imshow(Img, []);
title('Original');

subplot(2,2,2);
imshow(A.Img_Grad, []);
title('Gradient');

subplot(2,2,3);
imshow(A.Img_Morph, []);
title('Morph');

subplot(2,2,4);
title('Skeleton');
imshow(A.Img_Skelet, []);
title('Skeleton');

figure(2)
imshow(A.Img_Angle, []);
map=colormap(jet);
map(1,:) = 0;
colormap(map)
colorbar;
title(strcat('Angle: ',num2str(A.Angle),'°'));

