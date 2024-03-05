% Function to analyze two circle overlap. For two circles, the control variable is the ratio of distance 
% moved by the second circle to (2*r2). The metrics are the ratio of the distance moved
% by the centroid of the minima to the radii of individual circles.

function outCell = analyzeTwoCircle(N,nStep,r1,r2,theta,hMinArray)

locMins1 = twoCircleOverlap(N,nStep,r1,r2,theta,hMinArray);

shMin = max(size(hMinArray));

outCell = cell(shMin,4);

% Distance moved per step
xStep = (2*r2)/nStep;

for i = 1:1:shMin
    
    % hCell is the cell array for the given hMin
    % It has nStep rows and 3 columns with centres of the
    % two circles and regionprops in the third column
    hCell = locMins1{i,2};
    
    % Per step, find the number of minima and 
    % the distance moved by each minimum
    nMin = zeros(nStep,1);
    distMoved1 = zeros(nStep,2);
    distMoved2 = zeros(nStep,2);
    
    outCell{i,1} = hMinArray(i);
    
    % Loop to process each shift
    for j = 1:1:nStep
        
        xDist = j*xStep;   
        nMin(j) = numel(hCell{j,3});
                
        if ( numel(hCell{j,3}) == 1) % single minimum reached
            outCell{i,4} = xDist/(2*r2); % critical distance where minima merge
            break
        else
            % Centers of circles
            y1 = hCell{j,1}(1);
            x1 = hCell{j,1}(2);
            y2 = hCell{j,2}(1);
            x2 = hCell{j,2}(2);
                      
            distMoved1(j,1) = xDist/(2*r2);
            distMoved2(j,1) = xDist/(2*r2);
            
            % Centroids of minima
            xmin1 = hCell{j,3}(1).Centroid(1);
            ymin1 = hCell{j,3}(1).Centroid(2);
            xmin2 = hCell{j,3}(2).Centroid(1);
            ymin2 = hCell{j,3}(2).Centroid(2);
            
            distMoved1(j,2) = sqrt( (xmin1 - x1)^2 + (ymin1 - y1)^2)/r1;
            distMoved2(j,2) = sqrt( (xmin2 - x2)^2 + (ymin2 - y2)^2)/r2;     
        end
    end
       
    outCell{i,2} = distMoved1(1:j-1,:);
    outCell{i,3} = distMoved2(1:j-1,:);
end

            
            
    
    
    