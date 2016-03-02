clear 'all';
close 'all';

%linear gray wedge
Image = ones(20,1)*[0:255];

%add some constant lines
Image = [Image; 128*ones(5,256)];

%gamma 0.5
Image0_5 = ones(20,1)*[0:255];%???????????????
Image = [Image; Image0_5];

%add some constant lines
Image = [Image; 128*ones(5,256)];

%gamma 2
Image2_0 = ones(20,1)*[0:255];%???????????????
Image = [Image; Image2_0];

%plot it
figure(1);
imshow(uint8(Image))
text(10,15, 'Gamma = 1', 'Fontsize', 10, 'Color', [1 1 1]);
text(10,40, 'Gamma = 0.5', 'Fontsize', 10, 'Color', [1 1 1]);
text(10,65, 'Gamma = 2', 'Fontsize', 10, 'Color', [1 1 1]);

