function [ACR] = calc_Analytical_ACR( upper_Points, Lower_Points, circle_Centres_X, circle_Centres_Y, radii)
%UNTITLED2 Summary of this function goes here
%   Anaylically calculate ACR
%refer PhD book- entry 24th september 2020
%% delcaring global variables

global airfoil_Bottom_Equation;
global airfoil_Top_Equation;
global bumpy_Airfoil_Length_Ratio;

%% Calculating area of original airfoil till bumpy_Airfoil_Length_Ratio
T = bumpy_Airfoil_Length_Ratio;

diff_in_Coefficints = coeffvalues(airfoil_Top_Equation) - coeffvalues(airfoil_Bottom_Equation);
Original_Airfoil_Area = (  diff_in_Coefficints(1)*(T^(3/2))/ (3/2)  ) + (  diff_in_Coefficints(2)*(T^(3))/ (3)  ) + (  diff_in_Coefficints(3)*(T^(4))/ (4)  ) + (  diff_in_Coefficints(4)*(T^(5))/ (5)  ) + (  diff_in_Coefficints(5)*(T^(6))/ (6)  ) + (  diff_in_Coefficints(6)*(T^(4/3))/ (4/3)  );

%% calculating area of first circle
alpha(2) = rad2deg( atan( (upper_Points(1,2) - circle_Centres_Y(1)) / (upper_Points(1,1) - circle_Centres_X(1))));
alpha(3) = rad2deg( atan( (Lower_Points(1,2) - circle_Centres_Y(1)) / (Lower_Points(1,1) - circle_Centres_X(1))));

if(alpha(2)<0)% bringing fourth quadrant into 2nd quadrant
    alpha(2) = alpha(2) + 180;
end
alpha(3) = - alpha(3);
if(alpha(3)<0)
    alpha(3) = alpha(3) + 180;
end

thetha(1) = 180 - alpha(2);
thetha(2) = alpha(2) + alpha(3);
thetha(3) = 180 - alpha(3);

full_Circle_Area = pi() * (radii(1)*radii(1));
%Areas of the 4 sectors
Area(1) = (thetha(1)/360) * full_Circle_Area;
Area(2) = (radii(1)*radii(1)) * sin(deg2rad(thetha(2)));
Area(3) = (thetha(3)/360) * full_Circle_Area;
Compartment_Areas = zeros(size(radii,2),1);%preallocation 
Compartment_Areas(1) = sum(Area);

%% Finding areas of all compartments

upper_Points = [upper_Points ; (circle_Centres_X(end)+radii(end)), circle_Centres_Y(end)];
Lower_Points = [Lower_Points ; (circle_Centres_X(end)+radii(end)), circle_Centres_Y(end)];


for i = 2:(size(radii,2))
    alpha(1) = rad2deg( atan( (upper_Points(i-1,2) - circle_Centres_Y(i)) / (upper_Points(i-1,1) - circle_Centres_X(i))));
    alpha(2) = rad2deg( atan( (upper_Points(i,2) - circle_Centres_Y(i)) / (upper_Points(i,1) - circle_Centres_X(i))));
    alpha(3) = rad2deg( atan( (Lower_Points(i,2) - circle_Centres_Y(i)) / (Lower_Points(i,1) - circle_Centres_X(i))));
    alpha(4) = rad2deg( atan( (Lower_Points(i-1,2) - circle_Centres_Y(i)) / (Lower_Points(i-1,1) - circle_Centres_X(i))));
    %--------------------------------------
    if(alpha(2)<0)% bringing fourth quadrant into 2nd quadrant
        alpha(2) = alpha(2) + 180;
    end
    if(alpha(1)<0)
        alpha(1) = alpha(1)+180;
    end
    alpha(1) = 180 - alpha(1);
    alpha(3) = - alpha(3);
    if(alpha(3)<0)
        alpha(3) = alpha(3) + 180;
    end
    alpha(4) = - alpha(4);
    if(alpha(4)<0)
        alpha(4) = alpha(4)+180;
    end
    alpha(4) = 180 - alpha(4);
    %--------------------------------------
    thetha(1) = 180 - alpha(1) - alpha(2);
    thetha(2) = alpha(2) + alpha(3);
    thetha(3) = 180 - alpha(3) - alpha(4);
    thetha(4) = alpha(1) + alpha(4);
    %--------------------------------------
    full_Circle_Area = pi() * (radii(i)*radii(i));
    %Areas of the 4 sectors
    Area(1) = (thetha(1)/360) * full_Circle_Area;
    Area(2) = (.5 * radii(i)*radii(i)) * sin(deg2rad(thetha(2)));
    Area(3) = (thetha(3)/360) * full_Circle_Area;
    Area(4) = (.5 * radii(i)*radii(i)) * sin(deg2rad(thetha(4)));
    %--------------------------------------
    Compartment_Areas(i) = sum(Area);
end

Baffle_Airfoil_Area = sum(Compartment_Areas);

ACR = (Baffle_Airfoil_Area - Original_Airfoil_Area) / Original_Airfoil_Area;
ACR = abs(ACR);

end

