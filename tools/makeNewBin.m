% Important function to make a new binary where the invading blue
% epoxy regions are set to zero. 
% Inputs: 
% i_col : RGB original image
% i_bin : Original binary image
% redTol, greenTol : values of red and green colours. If both are set to
% zero, then only exact blue is chosen. Larger values lead to more
% approximate blue colours. 

function newBin = makeNewBin(i_col,i_bin, redTol, greenTol)

% Blues are set to zero, non blues are white

sbnil = setBlueZero(i_col, redTol, greenTol );

% Fill black spots in sbnil
sbnil = imfill(sbnil,'holes');

newBin = logical(i_bin) & logical(sbnil);


