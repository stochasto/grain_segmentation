% Function for watershed segmentation. 
% Inputs: 
% I : Image to be segmented. It can be rgb, grayscale or binary. If rgb,
% it is converted to grayscale, and then to binary. If gray, it is directly
% converted to binary using im2bw
% hmin : minima threshold
% d_metric : the metric to be used for distance transform, generally
% 'Euclidean' is used
% ismask : 0 for imhmin, 1 for imextendedmin. Both give same results
% Outputs: 
% W : Watershed line image
% I_seg : Final segmented binary image with watershed lines
% marker: Marker image with location of minima with depth greater than
% hmin.


function [W I_seg marker D] = make_watershed(I, hmin, d_metric, showIm)
if ndims(I) == 3
    igrey = rgb2gray(I);
else    
    igrey = I;
end

lev = graythresh(igrey);

% Binary image %
%ib = im2bw(igrey, lev);
ib = im2bw(igrey);
% imagesc(ib), colorbar, colormap('gray'), axis square, axis off
% title('Binary')
%%%%%%%%%%%%%%%%%%%%%

% Distance transform %
D = -bwdist(~ib,d_metric);
%D(~ib) = Inf;
%%%%%%%%%%%%%%%%%%%%%

if(showIm)
   figure
   imagesc(-D), colorbar, colormap('gray'), axis square, axis off
   title('Distance transform')
end

%%%% Obtain extended minima location image
marker = imextendedmin(D,hmin); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(showIm)
   figure
   imagesc(marker), colorbar, colormap('gray'), axis square, axis off
   title('The marker')
   figure
   imshowpair(ib,marker,'blend');
end

%%% Impose minima from marker on D, to get reduced minima transform
D2 = imimposemin(D,marker);
%%% Perform Watershed segmentation
W = watershed(D2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Transfer watershed lines on original image
I_seg = ib;
I_seg( W == 0) = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(showIm)
    figure
    imagesc(I_seg), colorbar, colormap('gray'), axis square, axis off;
    ht = sprintf('Segmented image hmin %f',hmin);
    title(ht)
end

%%%%%%%%%%%% OLD STUFF %%%%%%%%%%%%%%%

% figure
% imagesc(D), colorbar, colormap('gray'), axis square, axis off

%%% Minima %%%
%if (ismask == 0)
%    D = imhmin(D,hmin);
%     figure
%     imagesc(D), colorbar, colormap('gray'), axis square, axis off
%     title('D after mask')
%    W = watershed(D); % do watershed
%else

%%% Minima image, with depth lesser than hmin