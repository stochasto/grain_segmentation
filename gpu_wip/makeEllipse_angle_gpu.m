% makes ellipse

function E2 = makeEllipse_angle_gpu(N,eList)

s = gpuArray(size(eList));

if (s(1) <= 3)
    s = s(1);
else
    s = max(s);
end

E2 = zeros(N,N,'gpuArray');

expEll = zeros(1,1,'gpuArray');
i = zeros(1,1,'gpuArray');
j = zeros(1,1,'gpuArray');
k = zeros(1,1,'gpuArray');

%breakFlag = zeros(1,1,'gpuArray');


for i = 1:1:N
    %fprintf('Hello from the GPU\n');
    for j = 1:1:N
        for k = 1:1:s
            cy = eList(k,1);
            cx = eList(k,2);
            a = eList(k,3);
            b = eList(k,4);
            theta = eList(k,5);
            %if ( ((i - c(1))/a)^2 + ((j - c(2))/b)^2 ) <i= 1
            expEll = ( ( (i - cy)*cosd(theta) + (j - cx)*sind(theta))/a)^2;
            expEll = expEll + ( ( (i - cy)*sind(theta) - (j - cx)*cosd(theta))/b)^2;
            
            if expEll <= 1
                E2(i,j) = 1;
                %breakFlag = 0;
                %break
            end
        end
    end
end


%return
%end
