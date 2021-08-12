% all 3 coordinates is
%matrix- |x1 y1 0|
       % |x2 y2 0|
       % |a  b  c|
% such that the circle passes thorugh 2 points (x1,y1) and (x2,y2) and is
% tangential to the line ax +by +c = 0
function [ circle_Centre_X, circle_Centre_Y, radius ] = get_Circle_Data_Given_2_Points_1_Slope( all_3_Coordinates )


% extracting data from matrix- all_3_Coordinates as per discription above
x1 = all_3_Coordinates(1,1);
y1 = all_3_Coordinates(1,2);
x2 = all_3_Coordinates(2,1);
y2 = all_3_Coordinates(2,2);
a = all_3_Coordinates(3,1);
b = all_3_Coordinates(3,2);
c = all_3_Coordinates(3,3);

%generating 2 parabola equations by solving each point with tangent line
%equations in form of a1x^2 + b1xy + c1x + d1y^2 + e1y + f1 = 0


d1 = b^2;
b1 = -2*a*b;
e1 = -(2*x1*(a^2 + b^2)) - (2*a*c);
a1 = a^2;
c1 = -(2*y1*(a^2 + b^2)) - (2*b*c);
f1 = ((a^2 + b^2) * (x1^2 + y1^2)) - (c^2);
% similarly for second equation
d2 = b^2;
b2 = -2*a*b;
e2 = -(2*x2*(a^2 + b^2)) - (2*a*c);
a2 = a^2;
c2 = -(2*y2*(a^2 + b^2)) - (2*b*c);
f2 = ((a^2 + b^2) * (x2^2 + y2^2)) - (c^2);


%Various substituions while generating 4th order equation in C2

A = ((b1^2 * a2^2)/4) + ((b2^2 * a1^2)/4) - ((a1*a2*b1*b2)/2);
B = ((b1*c1*a2^2)/ 2 ) + ((b2*c2*a1^2)/ 2 ) - ((b1*c2 + c1*b2)*(a1*a2)*0.5);
G = ((c1^2*a2^2)/4) + ((c2^2*a1^2)/4) - ((c1*c2*a1*a2)/2);

C1 = (b1^2 - (4*a1*d1)) * (a2^2) / (4);
C2 = (b2^2 - (4*a2*d2)) * (a1^2) / (4);
D1 = (2*b1*c1 - 4*a1*e1) * (a2^2) / (4);
D2 = (2*b2*c2 - 4*a2*e2) * (a1^2) / (4);
E1 = (c1^2 - (4*a1*f1)) * (a2^2) / (4);
E2 = (c2^2 - (4*a2*f2)) * (a1^2) / (4);

P = A - C1 - C2;
Q = B - D1 - D2;
R = G - E1 - E2;
S = 4 * C1 * C2;
T = 4*(C1*D2 + C2*D1);
U = 4*(C1*E2 + D1*D2 + E1*C2);
V = 4*(D1*E2 + D2*E1);
W = 4 * E1 * E2;

% 4th order equation in C1 having coefficients
coefficients = [(P^2-S) (2*P*Q-T) (Q^2 + 2*P*R - U) (2*Q*R-V) (R^2-W)];

C1_Options = roots(coefficients);

% C1_Options should be 2, certain cases generate only one. incase this
% happens, just copy the first option as one and option 2

if size(C1_Options,1) == 1
    C1_Options(2) = C1_Options(1);
end
% getting C2 options
%C2 options from parabolas and first C1_options

coefficients = [a1 (b1*C1_Options(1) + c1) (d1*C1_Options(1)^2 + e1*C1_Options(1) + f1)];
C2_From_Parabola_1 = roots(coefficients);

coefficients = [a2 (b2*C1_Options(1) + c2) (d2*C1_Options(1)^2 + e2*C1_Options(1) + f2)];
C2_From_Parabola_2 = roots(coefficients);
roundn = @(x,n) round(x .* 10.^n)./10.^n;   % Round ‘x’ To ‘n’ Digits, Emulates Latest ‘round’ Function
C2_Options(1) = intersect(roundn(C2_From_Parabola_1,4), roundn(C2_From_Parabola_2,4));

%C2 options from  parabolas and second C1_options

coefficients = [a1 (b1*C1_Options(2) + c1) (d1*C1_Options(2)^2 + e1*C1_Options(2) + f1)];
C2_From_Parabola_1 = roots(coefficients);

coefficients = [a2 (b2*C1_Options(2) + c2) (d2*C1_Options(2)^2 + e2*C1_Options(2) + f2)];
C2_From_Parabola_2 = roots(coefficients);

C2_Options(2) = intersect(roundn(C2_From_Parabola_1,4), roundn(C2_From_Parabola_2,4));

%C2 getting radii options

r_Options(1) = ((x1- C1_Options(1))^2) + ((y1- C2_Options(1))^2);
r_Options(2) = ((x1- C1_Options(2))^2) + ((y1- C2_Options(2))^2);
r_Options = sqrt(r_Options);

% finding final C1, C2 and radius from 2 sets of options
[M,indice] = min(r_Options);
circle_Centre_X = C1_Options(indice);
circle_Centre_Y= C2_Options(indice);
radius = r_Options(indice);



end

