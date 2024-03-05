% Function to obtain the critical hMin for two ellipses
% Input: A -> Image with ellipses, hStep -> hmin step
% Output: critHmin -> hmin at which minima merge
%         numInitMin -> Initial minima at 0 hmin
%         initHeight -> Average initial heights of maxima

function [critHmin numInitMin] = getCritMinEllFast_gpu(N, A, b1)

h = gpuArray(0);
W = zeros(N,N,'gpuArray');
Ibin = zeros(N,N,'gpuArray');
emarker = zeros(N,N,'gpuArray');
D = zeros(N,N,'gpuArray');

fprintf('Hello from the GPU in ellFast\n');

[W Ibin emarker D] = make_watershed(A,h,'Euclidean',0);


%% Process minima depth

numInitMin = getNmin(emarker);

% x = find(emarker);
% sx = numel(x);
% o1 = ones(3,3);
% 
% initHeight = 0;
% 
% for i = 1:1:sx
%     % x-y coordinates of minima
%     xm = floor(x(i)/N) + 1;
%     ym = x(i) - (xm - 1)*N;
%     z = D(ym - 1:ym + 1,xm - 1:xm + 1) - D(ym,xm)*o1;
%     initHeight = initHeight + sum(z(:)); 
% end

%initHeight = sum(D(x));
%initHeight = -1.0*initHeight/numInitMin;

%nMin = numInitMin;


%% Perform hmin iterations

% Initial hmax set to make sure there is only one minimum
hMax = gpuArray(b1 + 1);
[W Ibin emarker D] = make_watershed(A,hMax,'Euclidean',0);

nMin = zeros(1,1,'gpuArray');
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
h2 = gpuArray(2.0*hNew);
h1 = gpuArray(hNew);

hMid = zeros(1,1,'gpuArray');

% Tolerance and difference
diff = gpuArray(20);
tol = gpuArray(5.0);

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
end
% while(nMin > 1)
%     h = h + hStep;
%     [W Ibin emarker D] = make_watershed(A,h,'Euclidean',0);
%     nMin = numel(regionprops(emarker));
% end

%  if (thread == 3)
%      disp('Reached here');
%      fprintf('j is %d and thread is %d\n', j, thread);
%  end


