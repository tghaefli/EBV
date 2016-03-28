% Author:   Fabian Niederberger
%           Pascal Häfliger
% Date:     2016-03-28
% Software: Octave 3.8.1 with package 'image'

close all; clear all; clc;

% ********************** READ IMAGE **********************
Path = './Images/Image_';
Nr = 003;
FileName = strcat(Path, sprintf('%03d', Nr), '.png');
Img = uint8(imread(FileName));



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

drawnow();


%% ************************ TEST ************************
for Nr=1:15

    FileName = strcat(Path, sprintf('%03d', Nr), '.png');
    Img = uint8(imread(FileName));
    A = angle_detection(Img, options);

    res(Nr,1) = Nr;
    res(Nr,2) = A.Angle;
end

res