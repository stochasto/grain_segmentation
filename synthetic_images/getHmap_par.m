% Function to obtain hmin map for two ellipses in various configurations.
% The first ellipse is vertical, the second is placed at various
% points on the plane, at various angles. For a given configuration, the
% following experiment is run. First, a grid is defined, on which the
% center of the second ellipse will be placed. At each such configuration,
% first, the h-value is set to b1 + 1, where b1 is the minor axis of the
% central ellipse. Then, 


%The end result is a series
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

function [hMap nMap] = getHmap_par(N, A, theta)

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
xmin = xc - (b1 + b2) - 5;
xmax = xc + (b1 + b2) + 5;
ymin = yc - (a1 + b2) - 5;
ymax = yc + (a1 + b2) + 5;

%% Steps
xStep = 1;
yStep = 1;

%xStep = 50;
%yStep = 50;


numX = floor((xmax - xmin)/xStep + 1);
numY = floor((ymax - ymin)/yStep + 1);

% Coordinates of roi
roiX = linspace(xmin, xmax, numX);
roiY = linspace(ymin, ymax, numY);

% Actual coordinates of center
[roi2X, roi2Y] = meshgrid(roiX, roiY);

% Indices of output cell
[i2, j2] = meshgrid(1:1:numX, 1:1:numY);

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
%heightMap = cell(numAngles,1);
%spanMap = cell(numAngles,1);

%% Parallel

numThreads = 32;
delete(gcp('nocreate'));
parpool(numThreads);

nTot = numX*numY;
nPoints = floor( (nTot + numThreads - 1)/numThreads );

%% Iterate over the plane and angles

tic;
for i = 1:1:numAngles
    eList{2,4} = theta(i);
    
    % grid format
    hMap{i} = zeros(numY, numX);
    nMap{i} = zeros(numY, numX);
    %heightMap{i} = zeros(numY, numX);
    %spanMap{i} = zeros(numY, numX);
    
    % grid adapted to parallelization
    critHmin = zeros(nPoints,numThreads);
    numInit = zeros(nPoints,numThreads);
    %initHeight = zeros(nPoints,numThreads);
    %sumSpan = zeros(nPoints,numThreads);
    
    parfor thread = 1:1:numThreads
        
        %thread
        eTemp = eList;
        hA = zeros(nPoints,1);
        nA = zeros(nPoints,1);
        iSpan = zeros(nPoints,1);
        ihA = zeros(nPoints,1);
        
        for j = 1:1:nPoints
            ind = (thread - 1)*nPoints + j;
            if (ind <= nTot)
            eTemp{2,1} = [roi2Y(ind) roi2X(ind)];
            E1 = makeEllipse_angle(N,eTemp); 
            %[hA(j),nA(j), ihA(j)] = getCritMinEllipse(N, E1, hStep);
            [hA(j),nA(j), iSpan(j), ihA(j)] = getCritMinEllFast(N, E1, b1);
            end
        end
        critHmin(:,thread) = hA;
        numInit(:,thread) = nA;
        %sumSpan(:,thread) = iSpan;
        %initHeight(:,thread) = ihA;
         %hMap{i}( (thread - 1)*nPoints + 1:thread*nPoints ) = critHmin(1:end);
         %nMap{i}((thread - 1)*nPoints + 1:thread*nPoints) = numInit(1:end);
         %thread
    end
    hMap{i} = reshape(critHmin(1:nTot),[numY, numX]);
    nMap{i} = reshape(numInit(1:nTot),[numY, numX]); 
    %spanMap{i} = reshape(sumSpan(1:nTot),[numY, numX]); 
    %heightMap{i} = reshape(initHeight(1:nTot),[numY, numX]);
end
toc
     
%% Write to excel

%resultDir = 'C:\Users\Vishal.Metri\Documents\Work\Grain Segmentation\synthetic\auto\test';
resultDir = '.'

for i = 1:1:numAngles
    %hMapFile = strcat(resultDir,'\hMapf_test.xlsx');
    %nMapFile = strcat(resultDir,'\nMapf_test.xlsx');
    %spanFile = strcat(resultDir,'\spanMapf_test.xlsx');
    
    fileStr = strcat('a1_',num2str(a1),'_b1_',num2str(b1),'_a2_',num2str(a2),'_b2_',num2str(b2));
    fileStr = strcat(fileStr,'_theta_',num2str(theta(i)));
    
    hMapFile = strcat('hMapf_',fileStr,'.xlsx');
    nMapFile = strcat('nMapf_',fileStr,'.xlsx');
    %spanFile = strcat('spanMapf_test.xlsx');
    %heightFile = strcat('heightMapf_test.xlsx');
    
    sheetName = strcat(num2str(theta(i)));
    writematrix(hMap{i},hMapFile,'Sheet',sheetName);
    writematrix(nMap{i},nMapFile,'Sheet',sheetName);
    %writematrix(spanMap{i},spanFile,'Sheet',sheetName);
    %writematrix(heightMap{i},heightFile,'Sheet',sheetName);
    %writematrix(heightMap{i},'heightMapf.xlsx','Sheet',sheetName);
end


