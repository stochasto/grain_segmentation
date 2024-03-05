% Function to obtain the critical hMin for two ellipses
% Input: A -> Image with ellipses, hStep -> hmin step
% Output: critHmin -> hmin at which minima merge
%         numInitMin -> Initial minima at 0 hmin
%         initHeight -> Average initial heights of maxima

function [critHmin numInitMin sumSpan initHeight] = getCritMinEllFast(N, A, b1)

h = 0;
[W Ibin emarker D] = make_watershed(A,h,'Euclidean',0);

%% Process minima depth

numInitMin = getNmin(emarker);

% Actual minima locations in marker, indices
% listMin = find(emarker);
% 
% % Number of minima
% numMinima = numel(listMin);
% 
% % XY coordinates of minima, column major
% minimaXY = zeros(numMinima,2);
% minimaXY(:,2) = floor(listMin(:)/N) + 1; % x
% minimaXY(:,1) = listMin(:) - (minimaXY(:,2) - 1)*N; %y
% 
% % Centroid
% meanX = mean(minimaXY(:,2));
% meanY = mean(minimaXY(:,1));
% 
sumSpan = 0;
initHeight = 0;
%
%%%%%%%%%%%%
% for i = 1:1:numMinima
%     % x-y coordinates of minima
%     %xm = floor(listMin(i)/N) + 1;
%     %ym = listMin(i) - (xm - 1)*N;
%     ym = minimaXY(i,1);
%     xm = minimaXY(i,2);
%     o1 = ones(3,3);
%     
%     xmDist = minimaXY(i,2) - meanX;
%     ymDist = minimaXY(i,1) - meanY;
%     
%     %sumSpan = sumSpan - D(listMin(i))*sqrt(xm^2 + ym^2);
%     %sumSpan = sumSpan + (xm^2 + ym^2);
%     z = D(ym - 1:ym + 1,xm - 1:xm + 1) - D(ym,xm)*o1;
%     sumSpan = sumSpan + sum(z(:));
%     %sumSpan = sumSpan + sum(z(:))*(xmDist^2 + ymDist^2);
%     %initHeight = initHeight + sum(z(:))*(xmDist^2 + ymDist^2);
%     %initHeight = initHeight + sum(z(:)); 
% end
% 
% spanX = max(minimaXY(:,2)) - min(minimaXY(:,2));
% spanY = max(minimaXY(:,1)) - min(minimaXY(:,1));
% % sumSpan = (spanX^2 + spanY^2)*max(-1.0*D(listMin));
% initHeight = (spanX^2 + spanY^2)*sumSpan;

%spanX = var(minimaXY(:,2));
%spanY = var(minimaXY(:,1));
%sumSpan = max(spanX,spanY);
%sumSpan = sqrt(spanX^2 + spanY^2);
%%%%%%%%%%%%

%initHeight = -1.0*sum(D(listMin));
%sumSpan = -1.0*sum(D(listMin));
%initHeight = -1.0*initHeight/numInitMin;

%nMin = numInitMin;


%% Perform hmin iterations

% Initial hmax set to make sure there is only one minimum
hMax = b1 + 1;
[W Ibin emarker D] = make_watershed(A,hMax,'Euclidean',0);
nMin = getNmin(emarker);

numIter = 0;

while ( nMin == 1)
    
    % Sometimes there can be only one min even for 0 hmin
    % Check for this and return
    if (hMax < 1e-6)
        critHmin = 0;
        return
    end
    
    hNew = 0.5*hMax;
    [W Ibin emarker D] = make_watershed(A,hNew,'Euclidean',0);
    nMin = getNmin(emarker);
    hMax = hNew;
    
%     if ((thread == 3) && ((j ==6) || (j == 7)))
%         fprintf('j is %d: hMax and nMin are %d and %d\n',j,hMax, nMin);
%     end
end  

% Get mid, and compute nmin
h2 = 2.0*hNew;
h1 = hNew;

% Tolerance and difference
diff = 20;
tol = 1e-1;

while (diff > tol)
    %h2 = 2.0*hNew;
    %h1 = hNew;
    hMid = 0.5*(h1 + h2);
    [W Ibin emarker D] = make_watershed(A,hMid,'Euclidean',0);
    nMin = getNmin(emarker);
    
    if (nMin == 1)
        h2 = hMid;
    else
        h1 = hMid;
    end
    
    numIter = numIter + 1;
    diff = h2 - h1;
        
end
    
critHmin = h1;
% while(nMin > 1)
%     h = h + hStep;
%     [W Ibin emarker D] = make_watershed(A,h,'Euclidean',0);
%     nMin = numel(regionprops(emarker));
% end

%  if (thread == 3)
%      disp('Reached here');
%      fprintf('j is %d and thread is %d\n', j, thread);
%  end


