% Function to set elements of a cell equal to zero, whose SIZE
% is less than thresh. For example, this can be used to set small 
% size connected components in an edge image equal to zero.

function c2 = setCellZero(c,thresh)

c2 = c;

% get list of sizes of each element
sizeList = cell_Length_check(c,0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s = numel(c);

for i = 1:1:s
    if(sizeList(i) <= thresh)
        c2{i} = 0;
    end
end
