% Function to extract a given colour region from a coloured binary
% A coloured binary is nothing but a 'binary' image where different phases
% are coloured differently.

function binTarget = extractRigidCol(imColBin,r,g,b)

s = size(imColBin);

binTarget = zeros(s(1),s(2));

x = find( (imColBin(:,:,1) == r) & (imColBin(:,:,2) == g) & (imColBin(:,:,3) == b) );

binTarget(x) = 1;