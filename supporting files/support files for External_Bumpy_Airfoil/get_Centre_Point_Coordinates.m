%------------------ Divide airfoil into n equal parts and get coordinates of airfoil centres----------------
%1) pass upper_curve and lower curve, and number of segments to devide
%airfoil into
%2) Get coordinates of centre line points

function [x y] = get_Centre_Point_Coordinates(curve_Top, curve_Bottom, n, type_Of_Baf_Placement, baffle_X_Coordinates )

if(strcmp(type_Of_Baf_Placement, 'equally_Spaced'))
    
    x = linspace(0,1,n+1);
    y = (curve_Top(x) + curve_Bottom(x))/2;
    
else
    x = baffle_X_Coordinates;
    y = (curve_Top(x) + curve_Bottom(x))/2;
end


end