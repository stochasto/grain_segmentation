% makes ellipse

function E1 = makeEllipse_angle(N,eList)

s = (size(eList));

if (s(1) <= 3)
    s = s(1);
else
    s = max(s);
end

E1 = zeros(N,N);

for i = 1:1:N
    for j = 1:1:N
        for k = 1:1:s
            c = eList{k,1};
            a = eList{k,2};
            b = eList{k,3};
            theta = eList{k,4};
            %if ( ((i - c(1))/a)^2 + ((j - c(2))/b)^2 ) <i= 1
            expEll = ( ( (i - c(1))*cosd(theta) + (j - c(2))*sind(theta))/a)^2;
            expEll = expEll + ( ( (i - c(1))*sind(theta) - (j - c(2))*cosd(theta))/b)^2;
            if expEll <= 1
                E1(i,j) = 1;
                break
            end
        end
    end
end
