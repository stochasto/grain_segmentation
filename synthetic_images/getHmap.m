% Function to obtain hmin map for two ellipses in various configurations.
% The first ellipse is vertical as usual, the second is placed at various
% points on the plane, at various angles. For a given configuration, the
% following experiment is run. First, a grid is defined, on which the
% center of the second ellipse will be placed. At each point, the hmin will
% be increased from 0 to the critical hmin, i.e. the hmin at which only one
% minimum remains. This will be recorded at this point. Also, at hmin 0,
% the total number of minima will be recorded. The end result is a series
% of 2D maps, at each point it carries the critical hmin and the number of
% initial minima. 
% Inputs: A -> array with major and minor axes of ellipses
%         theta -> array with angles, number of angles are numAngles
%         N -> size of image
%         hStep -> Stepsize for hmin
% Output: hMap -> Cell of size (numAngles,1), has map of critical hmin
%         nMap -> Cell of size (numAngles,1), has map of initial minima at
%         0 hmin.
% Note: For the second ellipse, at an angle of 0, a < b, i.e. the 0 degree
% ellipse is horizontal, with the vertical axis being a and horizontal
% being b.

function [hMap nMap heightMap] = getHmap(N, A, theta, hStep)

%% Get ellipse dimensions

a1 = A(1); % Vertical (major) axis of central ellipse
b1 = A(2); % Horizontal (minor) axis of central ellipse

a2 = A(3); % Vertical (minor) axis of moving ellipse
b2 = A(4); % Horizontal (major) axis of moving ellipse

%% Angle and map dimensions

numAngles = max(size(theta));

xc = 0.5*N;
yc = 0.5*N;

% Limits for centres, with a tolerance
xmin = xc - (b1 + b2) - 5
xmax = xc + (b1 + b2) + 5
ymin = yc - (a1 + b2) - 5
ymax = yc + (a1 + b2) + 5

%% Steps
xStep = 50;
yStep = 50;

numX = floor((xmax - xmin)/xStep + 1)
numY = floor((ymax - ymin)/yStep + 1)

% Coordinates of roi
roiX = linspace(xmin, xmax, numX);
roiY = linspace(ymin, ymax, numY);

%% Setup dimensions cell

eList = cell(2,4);

% Central ellipse
eList{1,1} = [yc xc];
eList{1,2} = a1;
eList{1,3} = b1;
eList{1,4} = 0;

% Moving ellipse
eList{2,2} = a2;
eList{2,3} = b2;

%% Allocate output cells

hMap = cell(numAngles,1);
nMap = cell(numAngles,1);
heightMap = cell(numAngles,1);

%% Iterate over the plane and angles
tic
for i = 1:1:numAngles
    eList{2,4} = theta(i);
    
    hMap{i} = zeros(numY, numX);
    nMap{i} = zeros(numY, numX);
    
    for col = 1:1:numX
        for row = 1:1:numY
            eList{2,1} = [roiY(row) roiX(col)];
            E1 = makeEllipse_angle(N,eList);
            [critHmin numInit initHeight] = getCritMinEllipse(N, E1, hStep);
            hMap{i}(row,col) = critHmin;
            nMap{i}(row,col) = numInit;
            heightMap{i}(row,col) = initHeight;
        end
    end
end
toc
    
    
    
    
