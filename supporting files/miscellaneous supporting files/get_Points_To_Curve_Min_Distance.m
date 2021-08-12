


function [error T1 T2 ] = get_Points_To_Curve_Min_Distance( airfoil_Top_Equation, airfoil_Bottom_Equation,Cx,Cy )
%GET_POINTS_TO_CURVE_MIN_DISTANCE Summary of this function goes here
%   Detailed explanation goes here

%----------------Finding normal to airfoil top----------------
T1_Squared = @(x) (Cx-x)^2 + (Cy-airfoil_Top_Equation(x))^2; %returns distance from circle centre point to point on upper airfoil
%declaring variables for fmincon to get smallest T1
x0 = Cx;
A = [];
b = [];
Aeq = [];
beq = [];
lb = 0;
ub = 1;
options = optimoptions('fmincon','Display','none');
x_Top = fmincon(T1_Squared,x0,A,b,Aeq,beq,lb,ub,[],options); % the intercept for the normal on the top airfoil
%------------------------------
T1 = sqrt(T1_Squared(x_Top));
%------------------------------

%----------------Finding normal to airfoil top----------------
T2_Squared = @(x) (Cx-x)^2 + (Cy - airfoil_Bottom_Equation(x))^2; %returns distance from circle centre point to point on upper airfoil
%declaring variables for fmincon to get smallest T1
x0 = Cx;
A = [];
b = [];
Aeq = [];
beq = [];
lb = 0;
ub = 1;
options = optimoptions('fmincon','Display','none');
x_Bottom = fmincon(T2_Squared,x0,A,b,Aeq,beq,lb,ub,[],options); % the intercept for the normal on the top airfoil

T2 = sqrt(T2_Squared(x_Bottom));

error = (T1 - T2)^2;

end

