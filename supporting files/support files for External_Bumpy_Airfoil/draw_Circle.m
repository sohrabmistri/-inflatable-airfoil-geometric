function draw_Circle( x, y, r )
%DRAW_CIRCLE Summary of this function goes here
%   Detailed explanation goes here

%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp);
z = 2;
hold on;

end
