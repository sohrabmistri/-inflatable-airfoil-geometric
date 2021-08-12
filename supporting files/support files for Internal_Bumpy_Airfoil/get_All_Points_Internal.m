% to get all centres, radii and cutting points on upper and lower airfoils
%--------------
% Returns
% upper_Points - 
% Lower_Points - 
% radii- 
% circle_Centres_X - 
% circle_Centres_Y - 
% error - 
% bumpy_airfoil_Top - 
% bumpy_Airfoil_Bottom - 
% bumpy_Airfoil_X

function [ upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y, error, bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X ] = get_All_Points_Internal( ~, ~,airfoil_Top_Equation, airfoil_Bottom_Equation,Cy_as_Func, r_as_Func, number_of_Compartments, type_Of_Baf_Placement, baffle_X_Coordinates, bumpy_Airfoil_Length_Ratio )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
warning off;
%global Cy_as_Func;
%global r_as_Func;
%tic;
if strcmp(type_Of_Baf_Placement , 'equally_Spaced')
    [Cx, Cy, r ] = get_Last_Circle_Data(  airfoil_Top_Equation, airfoil_Bottom_Equation, bumpy_Airfoil_Length_Ratio );
    x_Last = Cx;
    circle_Centres_Y = Cy;
    radii = r;
    %disp(['last baffle creation took ' num2str(toc)])
    %----------------------------------------------------
    %-------------Make First airfoil circle----------------------
    x_First= .04;
    %tic;
    %----------------------------------------------------
    %-------------Make All_Internal airfoil circles----------------------
    circle_Centres_X = linspace(x_First, x_Last, number_of_Compartments);
    
    for Xi  = circle_Centres_X(1:end-1)
        %[ Cy r ] = get_Tangent_Circle_Data( airfoil_Top_Equation, airfoil_Bottom_Equation, Xi );
        %[ Cy r ] = get_Tangent_Circle_Data_01( airfoil_Top_Equation, airfoil_Bottom_Equation, Xi );
        Cy = Cy_as_Func(Xi);
        r = r_as_Func(Xi);
        circle_Centres_Y = [circle_Centres_Y(1:end-1) Cy circle_Centres_Y(end)];
        radii = [radii(1:end-1) r radii(end)];
    end
    %disp(['Remaining baffles took ' num2str(toc)])
    
elseif strcmp(type_Of_Baf_Placement , 'unequally_Spaced')
    circle_Centres_X = baffle_X_Coordinates;
    
    circle_Centres_Y    = Cy_as_Func(circle_Centres_X )';
    radii               = r_as_Func(circle_Centres_X )';
%     Cy = Cy_as_Func(circle_Centres_X(1) );
%     r = r_as_Func(circle_Centres_X(1) );
%     circle_Centres_Y = [Cy];
%     radii = [r];
%     for Xi  = circle_Centres_X(2:end)
%         
%         Cy = Cy_as_Func(Xi);
%         r = r_as_Func(Xi);
%         circle_Centres_Y = [circle_Centres_Y Cy ];
%         radii = [radii r ];
%     end
end
 

%%
%tic;
[ upper_Points, Lower_Points ] = get_Upper_Lower_Intersection_Points( radii, circle_Centres_X, circle_Centres_Y );
%disp(['get_Upper_Lower_Intersection_Points took ' num2str(toc)])
%tic;
[ bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X ] = get_Bumpy_Airfoil(  upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y,  1,  1, number_of_Compartments);
%disp(['get_Bumpy_Airfoil took ' num2str(toc)])
%tic;
slope_of_first_baffle = (upper_Points(1,2) - Lower_Points(1,2)) /(upper_Points(1,1) - Lower_Points(1,2));
%draw_Bumpy_Airfoil( bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X, upper_Points, Lower_Points, number_of_Compartments, slope_of_first_baffle );
%disp(['draw_Bumpy_Airfoil took ' num2str(toc)])
%tic;
%error = find_Error( bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X, 'Not applicable'  );
error = calc_Analytical_ACR(upper_Points, Lower_Points, circle_Centres_X, circle_Centres_Y, radii);
%disp(['find_Error took ' num2str(toc)])
% error = 1;
 %bumpy_airfoil_Top = 1;
 %bumpy_Airfoil_Bottom = 1;
 %bumpy_Airfoil_X = 1;
%%
%----------------------------------------------------------------------------------------------
% for i = 1:size(radii,2)
% angle = 0: 2*pi/100:2*pi;
% circle_X = circle_Centres_X(i) + radii(i).*cos(angle);
% circle_Y = circle_Centres_Y(i) + radii(i).*sin(angle);
% hold on
% plot(circle_X, circle_Y)
% end

end

