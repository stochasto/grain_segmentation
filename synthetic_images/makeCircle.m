% Function to make a circle in an NxN image of rad pixel radius

function C1 = makeCircle(N, rad)

if (rad > 0.5*N - 3)
    disp('rad too big');
    return;
end

C1 = zeros (N,N);

circCentre = [floor(0.5*N) floor(0.5*N)];

sqRad = rad*rad;

for i = 1:1:N
    for j = 1:1:N
        if ( (i - circCentre(1))^2 + (j - circCentre(2))^2 < sqRad )
            C1(i,j) = 1;
        end
    end
end
