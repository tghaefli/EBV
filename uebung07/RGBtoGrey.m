clear all;  close all;  clc;


Image = imread('Strasse.png');

% Transform from RGB to Grey
Red   = 2989;
Green = 5870;
Blue  = 1140;

W_Red   = Red   / (Red + Green + Blue);
W_Green = Green / (Red + Green + Blue);
W_Blue  = Blue  / (Red + Green + Blue);

ImageGrey = W_Red   * Image.Red + ...
            W_Green * Image.Green + ...
            W_Blue  * Image.Blue;




% Transform from Grey to RGB
ImageRGB =  1/W_Red   * Image.Red + ...
            1/W_Green * Image.Green + ...
            1/W_Blue  * Image.Blue;






% Show result
subplot(3,1,1);
imshow(Image, []);

subplot(3,1,2);
imshow(ImageGrey, []);

subplot(3,1,3);
imshow(ImageRGB, []);

















