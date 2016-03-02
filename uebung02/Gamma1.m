clear 'all';
close 'all';

%read image
Image = imread('Monitor_Gamma.gif');
%plot it
figure(1);
imshow(Image);
title('Gamma correction image');

%read histgram
[Hist, Val] = imhist(Image);
%find non-zero values
Ind = find(Hist);
%skip black and white values
Ind = Ind(2:end-1);

%plot it
figure(2);hold on;
plot(Ind, 'bo');
title('histogram (excluding b&w');

%reproduce values using given power 1.00, 1.05, ...
Pow = [1:0.05:2.7];
%compare length
if length(Ind) == length(Pow)%otherwise sth. is wrong
    Val = 0.5*ones(1,length(Ind));
    Val = 255*(Val.^(1./Pow));
    plot(Val, 'r-')
end
xlabel('square index (1.00, 1.05, ..., 2.70)');
legend('values from image', '255 \cdot 0.5^{1/\gamma}, \gamma = 1.00, 1.05, ...');
ylabel('grey value');


%%%my gamma
MySx = 1000;
MySy = 599;
MyImage = uint8(zeros(MySy, MySx));
MyImage(1:2:end) = 255;

Dx = floor(MySx/15);
Dy = floor(MySy/11);

Cou = 0;
for iy = 1:5
    for ix = 1:7
        Pow = 1+Cou*0.05;
        Color = round(255*0.5^(1/Pow));
        MyImage(Dy*(2*iy-1):Dy*2*iy, Dx*(2*ix-1):Dx*2*ix) = Color;
        Cou = Cou+1;
    end
end

figure(3);
imshow(MyImage);