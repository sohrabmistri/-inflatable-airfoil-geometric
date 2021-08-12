clc;
clear;
addpath(genpath(pwd));
%% Greeting and introduction message
pause_time = .1;
disp('-----------------------------------------------------')
disp('Hello,'); pause(pause_time);
disp('I shall be converting the original smooth airfoil you specify to an inflatable airfoil');pause(pause_time);
disp('Follow the simple instructions below.');pause(pause_time);
disp('All dimensions are unitless, the original airfoil chord is considered as 1 unit length'); pause(pause_time);
disp('Kindly reference the original papers if publishing any work that directly or indirectly utilises this code');pause(pause_time);
disp(' ');
disp('Disclaimer: This code is for acedemic purposes only, the authors are no liable for incorrectness or any damage that may directly or indirectly occur by using this code');pause(pause_time);
disp(' ');
disp('-----------------------------------------------------');

%% Initiating main code- do not change anything

%% Global variables
global Original_X;
global Original_Y_Top;
global Original_Y_Bottom;
global cs_Top;
global cs_Bottom;
global cs_Middle;
global final_Number_Of_Compartments;
global  circle_Centres_X;
global airfoil_Top_Equation;
global airfoil_Bottom_Equation;

global Cy_as_Func;
global r_as_Func;
global bumpy_Airfoil_Length_Ratio;

global x_spacing;
%x_spacing = input('give number of spaces x axis should be devided into?(used for computation) = ');
x_spacing = 10000;

disp(' Please input the NACA 4 digit number one digit at a time:- ');
NACA_digit_1 = input('NACA 1st digit is (between 0 and 7):- ');
NACA_digit_2 = input('NACA 2nd digit is(between 0 and 7):- ');
NACA_digit_3 = input('NACA 3rd digit is(1 or 2):- ');
NACA_digit_4 = input('NACA 4th digit is(between 0 and 9):- ');

disp(['You have entered NACA ' num2str(NACA_digit_1) num2str(NACA_digit_2) num2str(NACA_digit_3) num2str(NACA_digit_4) ])
input('Press enter to confirm ----- or ----- press ctrl+c to restart');
NACA_Airfoil = [NACA_digit_1 NACA_digit_2 NACA_digit_3 NACA_digit_4];
disp(' ');
disp('-----------------------------------------------------')
disp('Evaluating NACA coordinates');
[Original_X_Top, Original_X_Bottom, Original_Y_Top, Original_Y_Bottom] = getNACA_Coordinates(50, NACA_Airfoil);

cs_Top = csapi(Original_X_Top, Original_Y_Top); %spline function for top
cs_Bottom = csapi(Original_X_Bottom, Original_Y_Bottom); %spline function for bottom

disp('Loading stored smooth airfoil spline and and compartment center data splines as a function of Cx');
% retrieving stored NACA Data
global stored_NACA_Airfoil_Data;
load('stored_NACA_Airfoil_Data');


%get equation of top and bottom airfoils using curve fitting
%[airfoil_Top_Equation, airfoil_Bottom_Equation] = fit_Airfoil_spline(Original_X_Top, Original_Y_Top, Original_X_Bottom, Original_Y_Bottom);
airfoil_Top_Equation = stored_NACA_Airfoil_Data(NACA_Airfoil(1) + 1, NACA_Airfoil(2) + 1 , (10*NACA_Airfoil(3)) + NACA_Airfoil(4)+ 1).top_Equation;
airfoil_Bottom_Equation = stored_NACA_Airfoil_Data(NACA_Airfoil(1) + 1, NACA_Airfoil(2) + 1 , (10*NACA_Airfoil(3)) + NACA_Airfoil(4)+ 1).bottom_Equation;
%% get internal baffle circle centre approximation and radius approximation as a function of Cx
%[Cy_as_Func, r_as_Func] = get_Internal_Circle_Spline_and_Radius_Equations(airfoil_Top_Equation,airfoil_Bottom_Equation);
Cy_as_Func = stored_NACA_Airfoil_Data(NACA_Airfoil(1) + 1, NACA_Airfoil(2) + 1 , (10*NACA_Airfoil(3)) + NACA_Airfoil(4)+ 1).Cy_Function;
r_as_Func = stored_NACA_Airfoil_Data(NACA_Airfoil(1) + 1, NACA_Airfoil(2) + 1 , (10*NACA_Airfoil(3)) + NACA_Airfoil(4)+ 1).r_Function;
clear Original_Data_Top % deleting original matrix as data has been extracted
clear Original_Data_Bottom % deleting original matrix as data has been extracted


Original_X = linspace(0,1,x_spacing); % creating x axis of equally distant points
Original_Y_Top = airfoil_Top_Equation(Original_X);
Original_Y_Bottom = airfoil_Bottom_Equation(Original_X);


disp('Basic computations done');
disp('-----------------------------------------------------')

%% Now computing inflatable airfoil parameters
disp(' ');
disp('-----------------------------------------------------')
disp('input the number of the correct option you want')
disp('Build bumpy airfoil type?')
disp('1: External ')
disp('2: Internal ')
global inflatable_Airfoil_Type;
inflatable_Airfoil_Type  = input('');

while (inflatable_Airfoil_Type ~= 1) & (inflatable_Airfoil_Type ~= 2)
    disp('Input only 1 or 2')
    inflatable_Airfoil_Type= input('');
end
if inflatable_Airfoil_Type == 1
    inflatable_Airfoil_Type = 'external';
elseif inflatable_Airfoil_Type == 2
    inflatable_Airfoil_Type = 'internal';
    
end
disp(['You have chosen inflatable airfoil type:- ' inflatable_Airfoil_Type]);

final_Number_Of_Compartments = input('Please put in the number of compartments:- ');


if inflatable_Airfoil_Type == 'internal'
    disp('________________________________________________')
    disp('Input the max allowable airfoil length as a % of full airfoil')
    disp('For example 90')
    bumpy_Airfoil_Length_Ratio= input('')/100; %the max allowable airfoil length full airfoil
    
    while (bumpy_Airfoil_Length_Ratio < .5) | (bumpy_Airfoil_Length_Ratio > .99)
        disp('Input must be between 50 and 99')
        bumpy_Airfoil_Length_Ratio= input('') / 100;
    end
end

%% Beginning to generate inflatable airfoil
disp(' ');
disp('-----------------------------------------------------')
disp('Beginning to generate infltable airfoil with equially spaced compartments')

if inflatable_Airfoil_Type == 'external'
    disp('  ')
    disp('Externally baffled airfoils take a few minutes to generate');
    disp('  ')
    i = final_Number_Of_Compartments;
    [upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y, error, bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X] = get_All_Points_External( airfoil_Top_Equation, airfoil_Bottom_Equation,i, 'equally_Spaced', [] );
    
elseif inflatable_Airfoil_Type == 'internal'
    i = final_Number_Of_Compartments;
    [upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y, error, bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X] = get_All_Points_Internal( cs_Top, cs_Bottom,airfoil_Top_Equation, airfoil_Bottom_Equation,Cy_as_Func, r_as_Func, i, 'equally_Spaced', [],bumpy_Airfoil_Length_Ratio );
end
disp('Done generating infltable airfoil')
disp('-----------------------------------------------------')

disp('              !!! attention !!!                      ')
disp([         'The ACR is ' num2str(error) '.'])

disp('-----------------------------------------------------')
%% Draw inflatable airfoil

[ bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X ] = get_Bumpy_Airfoil(  upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y,  'NA',  'NA', final_Number_Of_Compartments);
draw_Bumpy_Airfoil( bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X, upper_Points, Lower_Points, final_Number_Of_Compartments, 1 );

%% Time to retrieve the important data
disp(' ');
disp('----------------------------xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx----------------------------')
disp('----------------------------xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx----------------------------')
disp('----------------------------xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx----------------------------')
disp(' ');
disp(' ');
disp('------------Time to view the important data---------');
input(' Press enter to continue');
disp(['There are ' num2str(final_Number_Of_Compartments) ' number of compartments.']); pause(pause_time);
disp(['Following Data starts from the leading edge and ends at the trailing edge']); pause(pause_time);
disp(['All data is in the workspace']); pause(pause_time);
disp(['!!! Data for chord length equal to 1 unit for the original smooth airfoil']); pause(pause_time);
disp(' ');
disp(['Compartment Center x coordiates are stored in the variable :-     "circle_Centres_X"']); pause(pause_time);
disp(['Compartment Center y coordiates are stored in the variable :-     "circle_Centres_Y"']); pause(pause_time);
disp(['Compartment radii are stored in the variable :-                   "radii"']); pause(pause_time);
disp(' ');
disp(' ');
disp(['Top and bottom intersection coordinates are given in the variables     "upper_Points" and "Lower_Points"']); pause(pause_time);
disp('Format of these points are:-');
disp('x_coordinate of point 1, y_coordinateof point 1')
disp('x_coordinate of point 2, y_coordinateof point 2')
disp('x_coordinate of point 3, y_coordinateof point 3')
disp('         .             ,             .         ')
disp('         .             ,             .         ')
disp('         .             ,             .         '); pause(pause_time);

[circular_Fabric_length_Upper,circular_Fabric_length_Lower, baffle_Length] = get_Lengths_of_Fabrics(circle_Centres_X,circle_Centres_Y, radii, upper_Points, Lower_Points);

disp('-----------------------------------------------------')
disp('for the purposes of manufacturing, we need to know the arc lengths and baffles lengths');pause(pause_time);
disp(' ');
disp(['Baffle lengths are stored in the variable :-                   "baffle_Length"']); pause(pause_time);
disp(['Upper bulging fabric lengths are given in the variable :-      "circular_Fabric_length_Upper"']); pause(pause_time);
disp(['Lower bulging fabric lengths are given in the variable :-      "circular_Fabric_length_Lower"']); pause(pause_time);
disp(' ');

disp('      !!! Attention !!!');pause(pause_time);
disp('The front and rear compartment has only one baffle and an entire arc');pause(pause_time);
disp('Each arc is divided into segments:- upper and lower arcs');pause(pause_time);
disp('These arcs are considered as the first and last entry of the upper and lower bulging fabric lengths given in thier respective variables');pause(pause_time);

disp('-----------------------------------------------------')
disp(' ');
disp(' ');

disp('                     further !!!    '); pause(pause_time);
disp(' ');
disp('All above coordinates and measurements given for an original inflatable airfoil of chord length 1 unit'); pause(pause_time);
disp('To get the data for a required original smooth airfoil chord length:-'); pause(pause_time);
disp('Multiply all the above output coordinates and lengths by the required original smooth airfoil chord length'); pause(pause_time);
disp(' ');
disp(' ');
disp('----------------------------xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx----------------------------')
disp('----------------------------xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx----------------------------')
disp('----------------------------xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx----------------------------')

