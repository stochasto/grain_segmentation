% Function to obtain the spurious minima inside the overlap region
% with two corner pixels at diagonally opposite ends. The function plots
% the parabolic surfaces of Equation 1 from the paper and determines the
% line of intersection, Equation 3. It then tracks pixels along this line
% and for each pixel, checks 5 surrounding pixels towards either the bottom
% left corner or the top right corner, depending on whether it is closer to
% the other corner pixel, respectively. 
% Note that the internal co-ordinates used in the code are with respect to the
% bottom left corner pixel as origin.
% Input: cX1,cY1: X and Y coordinates of the bottom left corner pixel
%        cX2,cY2: X and Y coordinats of the top right corner pixel
% Output: The co-ordinates of spurious minima in the overlap region are
% printed out

function [x0 y0 minList] = findMinimaAbsolute(cX1,cY1,cX2,cY2)
%% Find width and height of overlap, call distance_surf to get x^2 + y^2 surface and plot line

% width
xc = abs(cX2 - cX1 + 1);
% height
yc = abs(cY1 - cY2 + 1);

% Plot parabolic surfaces
[surf1 surf2] = distance_surf(xc,yc);

% Line of intersection of surfaces in x-y plane
xLine = 0:0.1:xc;
yLine = -xLine*(xc/yc) + (0.5/yc)*(xc^2 + yc^2);
plot(xLine,yLine);

%% Book-keeping
minList = cell(xc,1);

%%% Find max and min limits of the border line
z = find(yLine > 0 & yLine <= yc);
s = max(size(z));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Integer coordinates of border line %%%%%
if (xc < yc)
    y0 = max(round(yLine(z)),1);
else
    y0 = max(floor(yLine(z)),1);
end
%%%%
x0 = min(floor(xLine(z)) + 1,xc); % adding 1 to convert to coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Minima finding loop

for i = 1:1:s
    s1 = surf1(y0(i),x0(i));
    s2 = surf2(y0(i),x0(i));
 
    minX = max([min(x0) x0(i) - 1]);
    maxX = min([max(x0) x0(i) + 1]);
    minY = max([min(y0) y0(i) - 1]);
    maxY = min([max(y0) y0(i) + 1]);
    
    if (s1 < s2) 
       
        % Check 5 neighbour pixels towards the top right corner pixel
        j1 = min([surf1(minY,maxX) surf2(minY,maxX)]);
        j2 = min([surf1(y0(i),maxX)     surf2(y0(i),maxX)]);
        j3 = min([surf1(maxY,maxX) surf2(maxY,maxX)]);
        j4 = min([surf1(maxY, x0(i)) surf2(maxY, x0(i))]);
        j5 = min([surf1(maxY,minX) surf2(maxY,minX)]);
        
        if (s1 > max([j1 j2 j3 j4 j5])) % Minimum found
            fprintf("s1 Max is at x = %d, y = %d, val is %f \n",(x0(i)+ cX1 - 1), (cY1 - y0(i) + 1), s1);
        end   
    else
        % Check 5 neighbour pixels towards the bottom left corner pixel
        j1 = min([surf1(minY,minX) surf2(minY,minX)]);
        j2 = min([surf1(y0(i), minX)     surf2(y0(i), minX)]);
        j3 = min([surf1(maxY, minX) surf2(maxY, minX)]);
        j4 = min([surf1(minY, x0(i)) surf2(minY, x0(i))]);
        j5 = min([surf1(minY, maxX) surf2(minY, maxX)]);
        
        if (s2 > max([j1 j2 j3 j4 j5])) % Minimum found
            fprintf("s2 Max is at x = %d, y = %d, val is %f \n",(x0(i)+ cX1 - 1), (cY1 - y0(i) + 1), s2);
        end
    end
end

x0 = x0';
y0 = y0';


