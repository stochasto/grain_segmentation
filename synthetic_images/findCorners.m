%% Function to determine corner points

function dFinal = findCorners(im)
%%
s = size(im);

numRows = s(1);
numCols = s(2);

%% Row Scan

dRow = im - circshift(im,1,2);

for i = 1:1:numRows
    m1 = find(dRow(i,:) == 1);
    if (m1 == 1) 
        dRow(i,m1) = 0;
        continue;
    else
        dRow(i,m1 - 1) = -1;
        dRow(i, m1) = 0;
    end
end

%% Column Scan
dCol = im - circshift(im,1,1);

for j = 1:1:numCols
    m1 = find(dCol(:,j) == 1);
    if (m1 == 1) 
        dCol(m1,j) = 0;
        continue;
    else
        dCol(m1 - 1,j) = -1;
        dCol(m1, j) = 0;
    end
end

%% Merge both

dRow = dRow*-1;
dCol = dCol*-1;

dFinal = logical(dRow) & logical(dCol);



