clear 'all';
close 'all';

%read image
Image = imread('London.png');

%calculate the mean and standard deviatione (square root of variance)
sprintf(' using matlabs own functions:\n mean = %4.2f \t standard deviation = %4.2f', mean2(Image), std2(Image))

%now we do the same thing using the histogram ?????
%get histogram values
[Count, Value] = imhist(Image);


%% Solution
%normalize the counts
Count = Count/sum(Count);
%determine mean as scalar product of Count and Value; therefore Count has
%to be transposed to row vector
Avg = Count'*Value;
%now determine standard deviation (remark the dot square to square each
%element of (Value - Avg)
Std = sqrt( Count'*(Value-Avg).^2 );
%output
sprintf(' using our own implementation:\n mean = %4.2f \t standard deviation = %4.2f', Avg, Std)
