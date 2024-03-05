function [y1, y2] = distance_surf(lx,ly)

%lx = 67;
%ly = 51;

x = (1:1:lx);
y = (1:1:ly);

[xx,yy] = meshgrid(x,y);

y1 = sqrt((xx - 1).^2 + (yy - 1).^2);
%y2 = zeros(N,N);
y2 = sqrt((xx - lx).^2 + (yy - ly).^2);

figure
surf(xx,yy,y1,'EdgeAlpha',0.25,'EdgeColor','g');
hold on
surf(xx,yy,y2,'EdgeAlpha',0.25,'EdgeColor','b');





