% to draw bumpy airfoil

function draw_Bumpy_Airfoil(  bumpy_Airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X, upper_Points, Lower_Points, number_of_Compartments, current_Slope_First_Baffle  )
% 
global Original_X;
global Original_Y_Top;
global Original_Y_Bottom;

%global airfoil_Top_Equation;
%global airfoil_Bottom_Equation;
current_Slope_First_Baffle = (upper_Points(1,2) - Lower_Points(1,2)) / (upper_Points(1,1) - Lower_Points(1,1));
current_Angle_first_Baffle = atan(current_Slope_First_Baffle) *180/pi();
    if current_Angle_first_Baffle <0
        current_Angle_first_Baffle = current_Angle_first_Baffle + 180;
    end
hold off
plot(Original_X, Original_Y_Top,'r')
hold on
plot(Original_X, Original_Y_Bottom,'b')

axis([-.1 1.1 -.6 .6])
plot(bumpy_Airfoil_X, bumpy_Airfoil_Top )
hold on
plot(bumpy_Airfoil_X, bumpy_Airfoil_Bottom )

%drawing baffles

n = size(upper_Points, 1);

%getting rid of imaginary parts otherwise an error is thrown
upper_Points = real(upper_Points);
Lower_Points = real(Lower_Points);
for i = 1:n
    plot([upper_Points(i,1) Lower_Points(i,1)] , [upper_Points(i,2) Lower_Points(i,2)])
end
title([ 'Number of compartments= ', num2str(number_of_Compartments), '  ||  Angle of First Baffle= ', num2str( current_Angle_first_Baffle) ])
drawnow 
end

