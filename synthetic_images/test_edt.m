% Test function to predict largest hmin
% The critical hmin (value at which there is only one min) can be reached
% in one of two ways. First is local filling. This is just the difference
% between the minimum and the nearest value among its 8-neighbours. Second
% is the difference between one of its 8-neighbours and other minima. If
% the second method value is lesser than the first, the min gets eaten up
% by a neighbouring patch before local filling occurs. The hLocal is the
% first and hOther are 8 values corresponding to the minimum diff between
% each 8-neighbour and other minima.

function [hLocal hOther min2] = test_edt(N,A)

h = 0;
[W Ibin emarker D] = make_watershed(A,h,'Euclidean',0);


%% Process minima depth

%numInitMin = getNmin(emarker);

% Actual minima locations in marker, indices
listMin = find(emarker);

% Number of minima
numMinima = numel(listMin);

% XY coordinates of minima, column major
minimaXY = zeros(numMinima,2);
minimaXY(:,2) = floor(listMin(:)/N) + 1; % x
minimaXY(:,1) = listMin(:) - (minimaXY(:,2) - 1)*N; %y

%% hLocal and zMin

hLocal = zeros(numMinima,1);
zMin = zeros(numMinima,1);
min2 = zeros(numMinima,1);
%hOther = zeros(numMinima,1);

hOther = ones(numMinima,9)*1e+9;


for i = 1:1:numMinima
    ym = minimaXY(i,1);
    xm = minimaXY(i,2);
    z = D(ym - 1:ym + 1,xm - 1:xm + 1); % the 3x3 patch around a min
    z(2,2) = 100; % set the min value to some large thing
    
    zMin(i) = min(z(:)); % Nearest value to min in the 8 neighbours
    
    hLocal(i) = zMin(i) - D(ym,xm); % hMin needed to erase local Min
    
    for j = 1:1:numMinima
        
        if (i ~= j)
            ym2 = minimaXY(j,1);
            xm2 = minimaXY(j,2);
            
            %hOther(i) = max(hOther(i), abs(zMin(i) - D(ym2,xm2)));
            for k = 1:1:9
                if (k ~= 5)
                    hOther(i,k) = min(hOther(i,k), abs(D(ym2,xm2) - z(k)));
                end
            end
        end
    end
   
end

for i = 1:1:numMinima
    min1 = min(hOther(i,:));
    min2(i) = min(min1,hLocal(i));
end

    
    
    