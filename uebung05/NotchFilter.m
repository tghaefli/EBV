
function [ Filter ] = NotchFilter( Size, Pos, Width )

Filter = ones(Size);

for Ind = 1:size(Pos,1)
   [XVal, YVal] = meshgrid([1:Size(2)]-Pos(Ind,2), [1:Size(1)]-Pos(Ind,1));
    
   %Filter = Filter.*(1-exp(-(XVal.*XVal+YVal.*YVal)/Width(Ind)));
   Filter((XVal.*XVal+YVal.*YVal) < Width(Ind)^2) = 0;
   %Filter((XVal.*XVal) < Width(Ind)^2) = 0;
end

end

