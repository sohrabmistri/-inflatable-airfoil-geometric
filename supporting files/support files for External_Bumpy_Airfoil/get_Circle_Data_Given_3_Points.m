% returns centre(x,y) and radius given 3 points

function [ circle_Centre_X, circle_Centre_Y, radius ] = get_Circle_Data_Given_3_Points( all_3_Coordinates )
%GET_CIRCLE_DATA_GIVEN_3_POINTS Summary of this function goes here
%   Detailed explanation goes here
B = (all_3_Coordinates(:,1).* all_3_Coordinates(:,1)) + (all_3_Coordinates(:,2).* all_3_Coordinates(:,2));
A = all_3_Coordinates*2;
A(:,3) = [1 1 1];
data = A\B;
data(3,1) = data(3,1) + (data(1,1)*data(1,1)) + (data(2,1)*data(2,1));

circle_Centre_X = data(1,1);
circle_Centre_Y = data(2,1);
radius = sqrt(data(3,1));


end

