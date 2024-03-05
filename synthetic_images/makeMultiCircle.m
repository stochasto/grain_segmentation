% Function to make multiple circles
% Input: N     -> Image size
%        clist -> 2d cell array of centres and radii
% For example, if we need two circles at centres (x1,y1) and (x2,y1)
% with radii r1 and r2, cList should look like: 
% cList{1,1} = (x1,y1); cList{1,2} = r1; cList{2,1} = (x2,y2, cList{2,2} = r2

function C2 = makeMultiCircle(N,cList)

numC = max(size(cList));

C2 = zeros(N,N);

for i = 1:1:N
    for j = 1:1:N
      if (~C2(i,j))
        for k = 1:1:numC
            c = cList{k,1};
            d = ( (i - c(1))^2 + (j - c(2))^2 );
            if d <= cList{k,2}^2
                C2(i,j) = 1;
                break
            end
        end
      end
    end
end





