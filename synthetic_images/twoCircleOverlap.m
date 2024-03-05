% Function to study effect of translation on watershed segmentation for two
% circles of arbitrary sizes overlapping at various degrees. 
% Input: N -> size of the image
%        r1, r2 - > radii of the two circles, with the left circle being
%        the larger one. 
%        nStep -> Number of shifts from starting position to full overlap
%        theta -> angle between line joining centres and x-axis
%        hMinArray -> Array of hmins
%          
% r1 >= r2, then the first configuration is such that both are just touching each other
% with center to center (CC) distance of (r1 + r2). Then the right
% circle is pushed into the left, for nStep points. Just when full overlap
% is reached, the CC distance is (r1 - r2). Thus, the right circle has
% moved a total of (r1 + r2) - (r1 - r2) = 2*r2 totally. Hence, distance
% moved by the x-coordinate of the center of the right circle per step is
% (2*r2)/nstep.
% 
% Output: locMins -> an {numhmin,2} cell. The first element is the hmin
% value, the second element is locMin, which is the result of the
% twoCircleOverlapWS code. It is a cell array with centers of both circles
% and a regionprops of the marker corresponding to each shift.

function locMins = twoCircleOverlap(N,nStep,r1,r2,theta,hMinArray)

sHmin = max(size(hMinArray));

locMins = cell(sHmin,2);

for i = 1:1:sHmin
    
    locMins{i,1} = hMinArray(i);
    locMins{i,2} = twoCircleOverlapWS_theta(N,nStep,r1,r2,theta,hMinArray(i));
end

    
    
    




