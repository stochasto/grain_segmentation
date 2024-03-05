% Function to plot distance transforms for multiple ellipse
% configurations. 

function multiEllipseDT(N,er,hmin)

x = 225:25:800;

s = numel(x);

numPlots = floor((s + 3)/4); % like in Cuda, (N + TPB - 1/TPB)

%% Subplot properties
sX = 0.45;
sY = 0.45;

p = {[ 0.045 0.515], [0.505 0.515],[0.045 0.025],[0.505 0.025]};

%% Save figure
dirName = 'C:\Users\Vishal.Metri\Documents\Work\Grain Segmentation\synthetic\ellipse_rotate\a50_b200';
figName = '\ang90_y400_';
%% DT and plotting

for i = 1:1:numPlots
    figure
    for j = 1:1:4
        ind = (i - 1)*4 + j;
        if ind > s
            break
        end
        er{2,1}(2) = x(ind);
        E1 = makeEllipse_angle(N,er);
        
        %%% Distance transform, minima extraction
        D = -bwdist(~E1,'Euclidean');
        marker = imextendedmin(D,hmin);
        sHand = subplot(2,2,j);
        set(sHand, 'Position', [p{j}(1) p{j}(2) sX sY]);
        imshowpair(E1,marker,'blend');
        title(num2str(x(ind)));
    end
    fName = strcat(dirName,figName,num2str(i),'.fig');
    savefig(fName);
end
        