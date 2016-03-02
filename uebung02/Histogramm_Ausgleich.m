clear 'all';
close 'all';

%read image
%Image = imread('London_squeez.png');
Image = imread('..\uebung01\London.png');
 
%plot the image 
figure(1);subplot(2,3,1);
imshow(Image);

%plot histogram
subplot(2,3,2);
[Hist, Val] = imhist(Image);
plot(Val, Hist, 'bo-');
axis([0 255 0 max(Hist)]);
xlabel('gray value');
ylabel('absolute frequency');

%plot cummulated hist
CumHist = cumsum(Hist)/sum(Hist);
subplot(2,3,3);
plot(Val, CumHist, 'bo-');
axis([0 255 0 1]);
xlabel('gray value');
ylabel('cumulated frequency');

%do the histogram equalization


%LUT for histogram equalization
LUT_Equ = uint8([0:255]);%???????????????????
%apply LUT
ImageEqu = intlut(Image, LUT_Equ);

subplot(2,3,4);
imshow(ImageEqu);

%plot histogram
%????????????????????

%plot cummulated hist
%????????????????????
