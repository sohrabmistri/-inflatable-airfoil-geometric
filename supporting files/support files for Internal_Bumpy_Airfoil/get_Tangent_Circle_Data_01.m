function [ Cy r ] = get_Tangent_Circle_Data_01(  airfoil_Top_Equation, airfoil_Bottom_Equation, Cx )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Cx
%fun = @(x) (((airfoil_Top_Equation(x(1)) - x(3))^2) + ((x(1) - Cx)^2) - ((airfoil_Bottom_Equation(x(2)) - x(3))^2) - ((x(2) - Cx)^2))^2;
%fun = @(x) (((airfoil_Top_Equation(x(1)) - x(3))^2) + ((x(1) - Cx)^2) - ((airfoil_Bottom_Equation(x(2)) - x(3))^2) - ((x(2) - Cx)^2))^2;%       + ((airfoil_Top_Equation(x(1)) - x(3))^2) + ((x(1) - Cx)^2)+((airfoil_Bottom_Equation(x(2)) - x(3))^2) + ((x(2) - Cx)^2) ;
fun = @(x) (((airfoil_Top_Equation(x(1)) - x(3))^2) + ((x(1) - Cx)^2) + ((airfoil_Bottom_Equation(x(2)) - x(3))^2) +((x(2) - Cx)^2));
x1_start = Cx;
x2_start = Cx;
Cy_start = (airfoil_Top_Equation(Cx) + airfoil_Bottom_Equation(Cx))/2;

options = optimoptions('fminunc','TolFun',1e-12);
options = optimoptions('fminunc','Display','iter-detailed');

[x,fval,exitflag,output] = fminunc(fun,[x1_start, x2_start, Cy_start],options);
Cy = x(3);
r = sqrt(((Cy - airfoil_Top_Equation(x(1)))^2) + ((Cx - x(1))^2));
end

