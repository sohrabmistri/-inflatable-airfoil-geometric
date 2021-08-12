function [bumpy_Airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X ] = get_Bumpy_Airfoil(  upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y,  ~,  ~, number_of_Compartments )
%GET_BUMPY_AIRFOIL Summary of this function goes here
%   Detailed explanation goes here
global x_spacing; %(x_spacing is global variable)
%bumpy_Airfoil_X = linspace(0,1,x_spacing); % creating x axis of equally distant points
bumpy_Airfoil_X = 0: 1/( x_spacing - 1 ) : (circle_Centres_X(end) + radii(end));
% generating Lower coordinates

j = 1; % compartment indice
%----------------------------------
%preallocating space
bumpy_Airfoil_Top = zeros(1, size(bumpy_Airfoil_X,2));
bumpy_Airfoil_Bottom = zeros(1, size(bumpy_Airfoil_X,2));
%----------------------------------
for i = 1:size(bumpy_Airfoil_X,2)
    if( j < number_of_Compartments)
        if(bumpy_Airfoil_X(i) > upper_Points(j,1))
            j = j+1;
        end
    end
    quadratic_Form(1) = 1;
    quadratic_Form(2) = -2*circle_Centres_Y(j);
    quadratic_Form(3) = (circle_Centres_X(j)^2) + (circle_Centres_Y(j)^2) - (radii(j)^2) + (bumpy_Airfoil_X(i)^2) - (2*circle_Centres_X(j)*bumpy_Airfoil_X(i));
    bumpy_Airfoil_Top(i) = max(roots(quadratic_Form));
end
% generating Lower coordinates

j = 1; % compartment indice

for i = 1:size(bumpy_Airfoil_X,2)
    if( j < number_of_Compartments)
        if(bumpy_Airfoil_X(i) > Lower_Points(j,1))
            j = j+1;
        end
    end
    quadratic_Form(1) = 1;
    quadratic_Form(2) = -2*circle_Centres_Y(j);
    quadratic_Form(3) = (circle_Centres_X(j)^2) + (circle_Centres_Y(j)^2) - (radii(j)^2) + (bumpy_Airfoil_X(i)^2) - (2*circle_Centres_X(j)*bumpy_Airfoil_X(i));
    bumpy_Airfoil_Bottom(i) = min(roots(quadratic_Form));
end
bumpy_Airfoil_Top = real(bumpy_Airfoil_Top);% to remove the complex part. Its anyway coming as 0.00i
bumpy_Airfoil_Bottom = real(bumpy_Airfoil_Bottom);

end

