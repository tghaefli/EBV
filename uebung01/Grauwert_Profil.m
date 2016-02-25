clear 'all';
close 'all';

%read image
Image = imread('London.png','png');

%plot the image 
figure(1);
imshow(Image);
title('London.png');

%shortcut for the image size
[Sy,Sx] = size(Image);

%plot the lines that are extracted
line([0 Sx], [100 100],'LineWidth',1,'Color',[1 0 0]);  %ordering is x11 x21 x31 ...      y11 y21 y31 ...
line([0 Sx], [200 200],'LineWidth',1,'Color',[0 1 0]);
line([0 Sx], [300 300],'LineWidth',1,'Color',[0 0 1]);

figure(2);hold on;
plot(Image(100,:),'r');
plot(Image(200,:),'g');
plot(Image(300,:),'b');

[Sy,Sx] = size(Image);
xlabel('column');
ylabel('grey value');