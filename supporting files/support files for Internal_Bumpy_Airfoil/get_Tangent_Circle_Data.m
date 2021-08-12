function [ Cy r ] = get_Tangent_Circle_Data(  airfoil_Top_Equation, airfoil_Bottom_Equation, Cx )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%error is the difference squared between the upper and lower radii from the point
%
% get_Tangent_Circle_Data_error_Function
%     function error_01 = get_Tangent_Circle_Data_error_Function(local_Cy)
%         error_01 = get_Points_To_Curve_Min_Distance(airfoil_Top_Equation, airfoil_Bottom_Equation,Cx,local_Cy);
%     end
error = @(Cy) get_Points_To_Curve_Min_Distance(airfoil_Top_Equation, airfoil_Bottom_Equation,Cx,Cy);
%declaring variables for fmincon to get smallest T1


A = [];
b = [];
Aeq = [];
beq = [];
lb = airfoil_Bottom_Equation(Cx);
ub = airfoil_Top_Equation(Cx);
x0 = (lb + ub)/2;
Cx;
options = optimoptions('fmincon','Display','none');
Cy = fmincon(error,x0,A,b,Aeq,beq,lb,ub,[],options); %Y location of circle centre that is tangential to top and bottom of airfoil
%Cy = Fibonacci_Minimization(error,lb,ub); %Y location of circle centre that is tangential to top and bottom of airfoil
[error T1 T2 ] = get_Points_To_Curve_Min_Distance(airfoil_Top_Equation, airfoil_Bottom_Equation,Cx,Cy);
r = (T1 +T2)/2;
%------------------------------------
% angle = 0: 2*pi/100:2*pi;
% circle_X = Cx + r.*cos(angle);
% circle_Y = Cy + r.*sin(angle);
% hold on
% plot(circle_X, circle_Y)
end

