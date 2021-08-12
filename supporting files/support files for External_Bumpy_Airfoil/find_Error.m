% find root mean square error
function [ error ] = find_Error( bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X, ~ )
%FIND_ERROR Summary of this function goes here
%   Detailed explanation goes here

%global Original_X;
global Original_Y_Top;
global Original_Y_Bottom;
% using rms of ratios
% middle_Points = fnval(cs_Middle, Original_X);
% 
% error_At_Each_Point = [(bumpy_airfoil_Top-Original_Y_Top) (bumpy_Airfoil_Bottom-Original_Y_Bottom)];
% required_Values = [(Original_Y_Top - middle_Points) (Original_Y_Bottom - middle_Points)];
% 
% squared_Error_Ratios = (error_At_Each_Point./required_Values).^2;
% 
% error = sqrt(mean(squared_Error_Ratios));
%% trimming smooth airfoil length to bumpy airfoil length
last_Point = bumpy_Airfoil_X(end);
indice = find(bumpy_Airfoil_X==last_Point);
local_Original_Y_Top = Original_Y_Top(1:indice);
local_Original_Y_Bottom = Original_Y_Bottom(1:indice);
 

%% using area ratio as error----------------------------

area_Bumpy_Airfoil = sum(bumpy_airfoil_Top - bumpy_Airfoil_Bottom);
area_Original_Airfoil = sum(local_Original_Y_Top - local_Original_Y_Bottom);
del_X = (bumpy_Airfoil_X(2) - bumpy_Airfoil_X(1));
area_Bumpy_Airfoil      = area_Bumpy_Airfoil      * del_X;
area_Original_Airfoil   = area_Original_Airfoil   * del_X;

error = (area_Bumpy_Airfoil - area_Original_Airfoil) / area_Original_Airfoil;
error = abs(error);
end

