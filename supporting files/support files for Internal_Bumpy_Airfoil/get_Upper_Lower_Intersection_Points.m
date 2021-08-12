%----Arguments-----------------------
%radii = radius of circles
%circle_Centres_X = x coordinate of circle centers
%circle_Centres_Y = y coordinate of circle centers

%----returns-----------------------
%upper_Points = (x,y) of upper intersection points
%Lower_Points = (x,y) of lower intersection points

function [ upper_Points, Lower_Points ] = get_Upper_Lower_Intersection_Points( radii, circle_Centres_X, circle_Centres_Y )
%UNTITLED2 Summary of this function goes here
%   Function returns upper and lower intersection points of all circles

%------------------------------------------------------------------
%preallocating the space of these variables
Lower_Points  = zeros((size(circle_Centres_X,2) - 1), 2);
upper_Points = zeros((size(circle_Centres_X,2) - 1), 2);

%------------------------------------------------------------------
for i = 1: (size(circle_Centres_X,2) - 1) % looping for all pairs of circles
    %creating equation of intersecting line as x = ay + b, purposely chose
    %x and not y as this wont cause singularieites/ NaNs if the line is vetical
    
    a = - (2*(circle_Centres_Y(i)-circle_Centres_Y(i+1))) / (2*(circle_Centres_X(i)-circle_Centres_X(i+1)));
    b = ((circle_Centres_X(i)^2-circle_Centres_X(i+1)^2) +(circle_Centres_Y(i)^2-circle_Centres_Y(i+1)^2) - (radii(i)^2-radii(i+1)^2)) / (2*(circle_Centres_X(i)-circle_Centres_X(i+1)));
    
    % creating quadratic in the form py^2 + qy + r = 0 (r not to be
    % mistaken with radii)
    
    p = (1 + a^2);
    q = ( (-2*circle_Centres_Y(i)) + (2*a*b) -(2*circle_Centres_X(i)*a) );
    r = ( (circle_Centres_Y(i)^2) - (2*circle_Centres_X(i)*b) +b^2 +(circle_Centres_X(i)^2) - (radii(i)^2) );
    
    y_intercepts = sort(roots( [p q r] ));
    %-------------------------------------------
    Lower_Points(i,2) = y_intercepts(1);
    Lower_Points(i,1) = a*y_intercepts(1) + b;
    
    upper_Points (i,2) = y_intercepts(2);
    upper_Points(i,1) = a*y_intercepts(2) + b;
    %-------------------------------------------
    

end

end

