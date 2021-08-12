% to get all data points such as radii etc given first baffle slope
% ----------------------------------------------------------------------------
%returns
% upper_Points - baffle end point coordinates on upper side
% Lower_Points - baffle end point coordinates on lower side
% radii - radii of each compartment
% circle_Centres_X - circle centre x coordinate of each compartment
% circle_Centres_Y - circle centre y coordinate of each compartment
% ----------------------------------------------------------------------------

function [ upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y ] = get_ALL_Points_Given_First_Slope( cs_Top, cs_Bottom, number_of_Compartments, centre_X, centre_Y, slope_of_first_baffle )
 tic
%get first baffle upper and lower coordinates
[upper_Points(1,1), upper_Points(1,2), Lower_Points(1,1), Lower_Points(1,2)]= get_Intersection_Points(cs_Top, cs_Bottom, slope_of_first_baffle, centre_X(2));
disp(' ');
disp('Calculating data for compartment 1')
%finding for first compartment radius and centre
three_Point_Cluster = [ upper_Points(1,1) upper_Points(1,2) 0;  Lower_Points(1,1), Lower_Points(1,2) 0; 1 0 0];
[ circle_Centres_X, circle_Centres_Y, radii ] = get_Circle_Data_Given_2_Points_1_Slope( three_Point_Cluster );

% upper_Points = 1;
% Lower_Points = 1;
% radii = 1;
% circle_Centres_X = 1;
% circle_Centres_Y = 1;

% finding all other baffle details

for i = 2:number_of_Compartments - 1
    disp(['Calculating data for compartment ' num2str(i)]);
    [upper_Points(i,1) upper_Points(i,2) Lower_Points(i,1) Lower_Points(i,2) circle_Centres_X(i) circle_Centres_Y(i) radii(i)] = find_Second_Baffle_Given_First( cs_Top, cs_Bottom, centre_X(i : i+1), centre_Y(i : i+1),upper_Points(i-1,:), Lower_Points(i-1,:), number_of_Compartments);

end

%finding for last compartment radius and centre
three_Point_Cluster = [ upper_Points(number_of_Compartments-1,1) upper_Points(number_of_Compartments-1,2) 0;  Lower_Points(number_of_Compartments-1,1), Lower_Points(number_of_Compartments-1,2) 0; 1 0 -1 ];
[ circle_Centres_X(number_of_Compartments), circle_Centres_Y(number_of_Compartments), radii(number_of_Compartments) ] = get_Circle_Data_Given_2_Points_1_Slope( three_Point_Cluster );
toc
end

