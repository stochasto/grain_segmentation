% Function to obtain the critical hMin for two ellipses
% Input: A -> Image with ellipses, hStep -> hmin step
% Output: critHmin -> hmin at which minima merge
%         numInitMin -> Initial minima at 0 hmin
%         initHeight -> Average initial heights of maxima

function [critHmin numInitMin initHeight] = getCritMinEllipse(N, A,hStep)

h = 0;
[W Ibin emarker D] = make_watershed(A,h,'Euclidean',0);

%% Process minima depth

rc = regionprops(emarker);
numInitMin = numel(rc);

x = find(emarker);
sx = numel(x);
o1 = ones(3,3);
initHeight = 0;

for i = 1:1:sx
    % x-y coordinates of minima
    xm = floor(x(i)/N) + 1;
    ym = x(i) - (xm - 1)*N;
    z = D(ym - 1:ym + 1,xm - 1:xm + 1) - D(ym,xm)*o1;
    initHeight = initHeight + sum(z(:)); 
end

%initHeight = sum(D(x));
%initHeight = -1.0*initHeight/numInitMin;

nMin = numInitMin;


%% Perform hmin iterations

while(nMin > 1)
    h = h + hStep;
    [W Ibin emarker D] = make_watershed(A,h,'Euclidean',0);
    nMin = numel(regionprops(emarker));
end

critHmin = h;
