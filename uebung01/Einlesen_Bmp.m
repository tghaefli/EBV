clear 'all';
close 'all';
%read image
File = fopen('London.bmp');

%first try read the bmp file header
bfType = fread(File, 2, 'int8=>char');
%is it realy a bitmap file? Note the prime as bfType is a column vector
if strcmp('BM', bfType')
    %read remaining parts of bmp file header
    bfSize = fread(File, 1, 'int');
    bfReserved1 = fread(File, 2, 'int8=>char');
    bfReserved2 = fread(File, 2, 'int8=>char');
    bfOffBits = fread(File, 1, 'int');

    %now read the bitmap info header
    biSize = fread(File, 1, 'int');
    biWidth = fread(File, 1, 'int');
    biHeight = fread(File, 1, 'int');
    biPlanes = fread(File, 1, 'int16');
    biBitCount = fread(File, 1, 'int16');
    biCompression = fread(File, 1, 'int');
    biSizeImage = fread(File, 1, 'int');
    biXPelsPerMeter = fread(File, 1, 'float');
    biYPelsPerMeter = fread(File, 1, 'float');
    biClrUsed = fread(File, 1, 'int');
    biClrImportant = fread(File, 1, 'int');
    
    %read the colour map (color wise)
    bmiColors = fread(File, [4 256], 'uint8');
    
    %now read the data (row wise)
    imageData = fread(File, [biWidth*biBitCount/8 biHeight], 'uint8');

    %now show image (flip the data first and read it upside down)
    imshow(mat2gray(imageData(:,end:-1:1)'))
end
