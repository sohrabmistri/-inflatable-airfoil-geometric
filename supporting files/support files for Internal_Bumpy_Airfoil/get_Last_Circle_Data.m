

function [Cx Cy r ] = get_Last_Circle_Data( airfoil_Top_Equation, airfoil_Bottom_Equation, bumpy_Airfoil_Length_Ratio )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global Cy_as_Func;
global r_as_Func;

% ---------Approximating Boundary of search--------
%These are approximations to give best bounds of search
%to get equation of angle bisectors in the form y = m1x + c1 for top and y2
%= m2x + c2 for bottom
approximat_Slope_of_Upper = ( airfoil_Top_Equation(bumpy_Airfoil_Length_Ratio) - airfoil_Top_Equation(bumpy_Airfoil_Length_Ratio-.1))/ ( bumpy_Airfoil_Length_Ratio - (bumpy_Airfoil_Length_Ratio-.1));
approximat_angle_of_Upper = (atan(approximat_Slope_of_Upper))*180/pi;
approximat_angle_of_Upper = approximat_angle_of_Upper + 180;
m1 = tan((pi/180)*((approximat_angle_of_Upper+270)/2));
c1 = airfoil_Top_Equation(bumpy_Airfoil_Length_Ratio) - (m1*bumpy_Airfoil_Length_Ratio);

approximat_Slope_of_Lower = ( airfoil_Bottom_Equation(bumpy_Airfoil_Length_Ratio) - airfoil_Bottom_Equation(bumpy_Airfoil_Length_Ratio-.1))/ ( bumpy_Airfoil_Length_Ratio - (bumpy_Airfoil_Length_Ratio-.1));
approximat_angle_of_Lower = (atan(approximat_Slope_of_Lower))*180/pi;
approximat_angle_of_Lower = approximat_angle_of_Lower + 180;
m2 = tan((pi/180)*((approximat_angle_of_Lower+90)/2));
c2 = airfoil_Bottom_Equation(bumpy_Airfoil_Length_Ratio) - (m2*bumpy_Airfoil_Length_Ratio);

x3 = (c2-c1)/(m1-m2);
x1 = x3 - ((bumpy_Airfoil_Length_Ratio - x3)/2);%taking lower bound behind from centre by half of approximate r
x2 = x3 + ((bumpy_Airfoil_Length_Ratio - x3)/2);
% ---------setting bounds of search----------------
% x1 = 0.5;
% x2 = bumpy_Airfoil_Length_Ratio;
% x3 = (x1+x2)/2;

% ---------Setting search parameters----------------
acceptable_Residue = 10^-5;
max_Iterations = 25;
range = 1; %arbitary value to start the iterative loop
i = 1; %iteration 1
% -------------Iterative loops ---------------------
while (i<max_Iterations) & (range>acceptable_Residue)
    %disp(['iternation number:' num2str(i)])
    %disp([ num2str(x1) '  ' num2str(x2) '  ' num2str(x3)])
    
    %[ y1 r1 ] = get_Tangent_Circle_Data( airfoil_Top_Equation, airfoil_Bottom_Equation, x1 );
    y1 = Cy_as_Func(x1);
    r1 = r_as_Func(x1);
    %[ y2 r2 ] = get_Tangent_Circle_Data( airfoil_Top_Equation, airfoil_Bottom_Equation, x2 );
    y2 = Cy_as_Func(x2);
    r2 = r_as_Func(x2);
    %[ y3 r3 ] = get_Tangent_Circle_Data( airfoil_Top_Equation, airfoil_Bottom_Equation, x3 );
    y3 = Cy_as_Func(x3);
    r3 = r_as_Func(x3);
    error1 = bumpy_Airfoil_Length_Ratio - (x1 + r1);
    error2 = bumpy_Airfoil_Length_Ratio - (x2 + r2);
    error3 = bumpy_Airfoil_Length_Ratio - (x3 + r3);
    
    if error1*error3<0 % checking if signs of the 2 terms are opposite
        x1 = x1;
        x2 = x3;
        x3 = (x1+x2)/2;
    else
        x1 = x3;
        x2 = x2;
        x3 = (x1+x2)/2;
    end
    range = x2 - x1;
    i = i+1;
    Cx = x1;
    Cy = y1;
    r  = r1;
    
end

end

