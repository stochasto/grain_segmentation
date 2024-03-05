function im2 = copyWshedLines(imRgb,imWS)

s = size(imWS);

%% Make a zero image, transfer watershed lines in imWS to it
wb = zeros(s(1),s(2));

wb( imWS == 0 ) = 1;

wb = ~wb; % Complement so that only watershed lines are 0

%% Set watershed lines to red in original rgb image

im2 = imRgb;

r = im2(:,:,1);
g = im2(:,:,2);
b = im2(:,:,3);

x = find(wb == 0); % these are watershed lines

% set to red
r(x) = 255; 
g(x) = 0;
b(x) = 0;

im2(:,:,1) = r;
im2(:,:,2) = g;
im2(:,:,3) = b;

