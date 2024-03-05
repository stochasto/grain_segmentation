
addpath('~/workdir_ir7/Code/grain_segmentation/synthetic_images');
addpath('~/workdir_ir7/Code/grain_segmentation/tools');

a1 = 100
b1 = 50
a2 = 50
b2 = 100

N = 1000

theta = 0

A = zeros(4,1);

A(1) = a1
A(2) = b1
A(3) = a2
A(4) = b2

%N = 1000

%theta = [0]

[hMap nMap] = getHmap_par(N,A,theta);

