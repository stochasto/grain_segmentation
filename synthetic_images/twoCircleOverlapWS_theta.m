% Function to check distance transform watershed analytically. First
% Make two circles and push the right one into the left in stages. The
% smaller circle is always to the right. 
% If the radii of the two circles are r1 and r2 with r1 >= r2, then the
% first configuration is such that both are just touching each other at the
% y-axis, with center to center (CC) distance of (r1 + r2). Then the right
% circle is pushed into the left, for nStep points. Just when full overlap
% is reached, the CC distance is (r1 - r2). Thus, the right circle has
% moved a total of (r1 + r2) - (r1 - r2) = 2*r2 totally. Hence, distance
% moved by the x-coordinate of the center of the right circle per step is
% (2*r2)/nstep.
% theta is the angle between line joining centres and the x-axis. It can
% vary from 0 to 90 degrees.
% Output is the structure locMin. It is a cell of size (nStep,3). First two
% elements per row are the centers of both circles and the third is a
% regionprops structure of the marker image of each step. The marker image
% contains only the minima of the distance transform, for a given value of
% hmin. So, the 'Centroid' attribute of this cell gives the number and
% location of the centroids of the minima. 


function locMin = twoCircleOverlapWS_theta(N,nStep,r1,r2,theta,hmin)
%% Find the watershed function
addpath('../tools');

halfN = 0.5*N;

%% Define circles
cList = cell(1,2);
cList{1,1} = [ halfN (halfN - r1)];
cList{1,2} = r1;
cList{2,1} = [(halfN - (r1 + r2)*sind(theta)) (halfN - r1 + (r1+r2)*cosd(theta))];
cList{2,2} = r2;

%% Set step size array xStep, with nStep elements
xStep = (2*r2)/nStep;

%% Define output cell locMin
locMin = cell(nStep,2);

%% Call makeMultiCircle at each step to make the overlapping circles and segment
for i = 1:1:nStep
    dist = (r1 + r2) - i*xStep;
    cList{2,1} = [(halfN - dist*sind(theta)) (halfN - r1 + dist*cosd(theta))];
    % Make overlapping circles, with right circle shifted to the left
    C2 = makeMultiCircle(N,cList);
    % Watershed
    [W_c Ibin_c mc] = make_watershed(C2,hmin,'Euclidean',0);
    % Get results, mc is the marker image with locations of minima
    locMin{i,1} = cList{1,1};
    locMin{i,2} = cList{2,1};
    locMin{i,3} = regionprops(mc);
end

