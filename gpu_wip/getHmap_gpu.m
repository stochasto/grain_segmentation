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

function [hMap nMap heightMap] = getHmap_gpu(N, A, theta)

%% Get ellipse dimensions

a1 = A(1); % Vertical (major) axis of central ellipse
b1 = A(2); % Horizontal (minor) axis of central ellipse

b1_g = gpuArray(b1);

a2 = A(3); % Vertical (minor) axis of moving ellipse
b2 = A(4); % Horizontal (major) axis of moving ellipse

%% Angle and map dimensions

numAngles = max(size(theta));

xc = 0.5*N;
yc = 0.5*N;

N_g = gpuArray(N);

% Limits for centres, with a tolerance
xmin = xc - (b1 + b2) - 5;
xmax = xc + (b1 + b2) + 5;
ymin = yc - (a1 + b2) - 5;
ymax = yc + (a1 + b2) + 5;

%% Steps
%xStep = 1;
%yStep = 1;

xStep = 100;
yStep = 100;


numX = floor((xmax - xmin)/xStep + 1);
numY = floor((ymax - ymin)/yStep + 1);

% Coordinates of roi
roiX = gpuArray(linspace(xmin, xmax, numX));
roiY = gpuArray(linspace(ymin, ymax, numY));

% Actual coordinates of center
[roi2X, roi2Y] = meshgrid(roiX, roiY);

% Indices of output cell
%[i2, j2] = meshgrid(1:1:numX, 1:1:numY);

%% Setup dimensions cell

%eList = cell(2,4);
eList = zeros(2,5,'gpuArray');

% Central ellipse
% eList(1,1) = gpuArray(yc);
% eList(1,2) = gpuArray(xc);
% eList(1,3) = gpuArray(a1);
% eList(1,4) = b1_g;
% eList(1,5) = gpuArray([0]);

eList(1,1) = yc;
eList(1,2) = xc;
eList(1,3) = a1;
eList(1,4) = b1_g;
eList(1,5) = gpuArray([0]);

% Moving ellipse
eList(2,3) = a2;
eList(2,4) = b2;

%% Allocate output cells

hMap = cell(numAngles,1);
nMap = cell(numAngles,1);
heightMap = cell(numAngles,1);

%% Parallel

numThreads = 1;
delete(gcp('nocreate'));
parpool(numThreads);

nTot = numX*numY;
nTot_g = gpuArray(nTot);
nPoints = floor( (nTot + numThreads - 1)/numThreads );

%% Iterate over the plane and angles

tic;
for i = 1:1:numAngles
    %eList(2,5) = gpuArray(theta(i));
    eList(2,5) = theta(i);
    
    hMap{i} = zeros(numY, numX);
    nMap{i} = zeros(numY, numX);
    %heightMap{i} = zeros(numY, numX);
    
    critHmin = zeros(nPoints,numThreads);
    numInit = zeros(nPoints,numThreads);
    %initHeight = zeros(nPoints,numThreads);
    
    parfor thread = 1:1:numThreads
        
        %thread
        eTemp = gpuArray(eList);
        
        hA = gpuArray(zeros(nPoints,1));
        nA = gpuArray(zeros(nPoints,1));
        E1 = gpuArray(zeros(N,N));
        %ihA = zeros(nPoints,1);
        
        for j = 1:1:nPoints
            ind = (thread - 1)*nPoints + j;
            if (ind <= nTot_g)
            eTemp(2,1) = roi2Y(ind);
            eTemp(2,2) = roi2X(ind);
            %fprintf('Before\n');
            E1 = makeEllipse_angle_gpu(N_g,eTemp); 
            %[hA(j),nA(j), ihA(j)] = getCritMinEllipse(N, E1, hStep);
            [hA(j),nA(j)] = getCritMinEllFast_gpu(N_g, E1, b1_g);
             disp('after')
            end
        end
        thread
        critHmin(:,thread) = gather(hA);
        numInit(:,thread) = gather(nA);
        %initHeight(:,thread) = ihA;
         %hMap{i}( (thread - 1)*nPoints + 1:thread*nPoints ) = critHmin(1:end);
         %nMap{i}((thread - 1)*nPoints + 1:thread*nPoints) = numInit(1:end);
         %thread
    end
    hMap{i} = reshape(critHmin(1:nTot),[numY, numX]);
    nMap{i} = reshape(numInit(1:nTot),[numY, numX]); 
    %heightMap{i} = reshape(initHeight(1:nTot),[numY, numX]);
end
toc
     
%% Write to excel

for i = 1:1:numAngles
    sheetName = strcat(num2str(theta(i)));
    writematrix(hMap{i},'hMapf.xlsx','Sheet',sheetName);
    writematrix(nMap{i},'nMapf.xlsx','Sheet',sheetName);
    %writematrix(heightMap{i},'heightMapf.xlsx','Sheet',sheetName);
end


