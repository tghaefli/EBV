function [ coeff] = DistFunction(dist1, dist2 )
%Calculate the distance coefficient between two distributions

%coeff = sum(sqrt(dist1 .* dist2));  %the Bhattacharyya coefficient
%coeff = sum(dist1 .* log(max(dist2,1))); %the relative entropy (value is not symmetric
                                        %and result depends upon the order
                                        %of the distributions!!
coeff = 1/norm(dist1-dist2);     %euclidean distance                               
end

