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

function [ upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y, error, bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X ] = get_All_Points_External( cs_Top, cs_Bottom, number_of_Compartments, type_Of_Baf_Placement, baffle_X_Coordinates )
global cs_Middle;

%------------------ Divide airfoil into n equal parts and get coordinates of airfoil centres----------------
disp(['computing for ',  num2str(number_of_Compartments), ' number of compartments' ])
[centre_X  centre_Y] = get_Centre_Point_Coordinates(cs_Top, cs_Bottom, number_of_Compartments, type_Of_Baf_Placement, baffle_X_Coordinates );

%------------------ generate centre spline and get fisrt baffle angle/ slope----------------

cs_Middle = csapi(centre_X, centre_Y);
cs_Middle_der = fnder(cs_Middle, 1);
slope_of_first_baffle = -1 / fnval(cs_Middle_der, centre_X(2));
% if slope_of_first_baffle< 0 % if angle is showing negative, to correct it to be between 90 and 180 degrees
%     slope_of_first_baffle =180 + slope_of_first_baffle;
% end

%------------------ get all data given first baffle angle/ slope ----------------

[ upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y ] = get_ALL_Points_Given_First_Slope( cs_Top, cs_Bottom, number_of_Compartments, centre_X, centre_Y, slope_of_first_baffle );
[ bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X ] = get_Bumpy_Airfoil(  upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y,  centre_X,  centre_Y, number_of_Compartments);
%draw_Bumpy_Airfoil( bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X, upper_Points, Lower_Points, number_of_Compartments, slope_of_first_baffle );
error = find_Error( bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X, cs_Middle  );

%baffle_angle_optimization_handler(  cs_Top, cs_Bottom, number_of_Compartments, type_Of_Baf_Placement, baffle_X_Coordinates  )

%------------------ get all data varying first baffle angle/ slope ----------------
% j = 1;
% for i = 0:.5:0 %varying angles coursely then finely later on
%     
%     current_Slope_First_Baffle = tan(((atan(slope_of_first_baffle)*180/pi())+i)*pi()/180);
%     current_Angle_first_Baffle = atan(current_Slope_First_Baffle) *180/pi();
%     if current_Angle_first_Baffle <0
%         current_Angle_first_Baffle = current_Angle_first_Baffle + 180;
%     end
%     %current_Slope_First_Baffle = (slope_of_first_baffle + tan(i*pi()/180) ) / (1 - (slope_of_first_baffle * tan(i*pi()/180)));
%     disp(['computing for ',  num2str(current_Angle_first_Baffle), ' angle of first baffle' ])
%     [ upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y ] = get_ALL_Points_Given_First_Slope( cs_Top, cs_Bottom, number_of_Compartments, centre_X, centre_Y, current_Slope_First_Baffle );
%     [ bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X ] = get_Bumpy_Airfoil(  upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y,  centre_X,  centre_Y, number_of_Compartments);
%     draw_Bumpy_Airfoil( bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X, upper_Points, Lower_Points, number_of_Compartments, current_Slope_First_Baffle );
%     error = find_Error( bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X, cs_Middle  );
%     error_plot_VS_angle(1,j) = error;
%    
%     error_plot_VS_angle(2,j) = (atan(current_Slope_First_Baffle) *180/pi());
%     
%     
%     if error_plot_VS_angle(2,j)< 0 % if angle is showing negative, to correct it to be between 90 and 180 degrees
%         error_plot_VS_angle(2,j) =180 + error_plot_VS_angle(2,j);
%     end
%     
%     j= j+1;
% end
% [min_Error position_Min_Error] = min(error_plot_VS_angle(1,:)); % getting minimum error
% current_Angle_Min_Error = error_plot_VS_angle(2,position_Min_Error); % getting angle that gives minimum error
% 
% 
% % for i = (current_Angle_Min_Error-1):0.1:(current_Angle_Min_Error+1) %varying angles coursely then finely later on
% %     
% %     current_Slope_First_Baffle = tan(i*pi()/180);
% %     disp(['computing for ',  num2str(atan(current_Slope_First_Baffle) *180/pi()), ' angle of first baffle' ])
% %     [ upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y ] = get_ALL_Points_Given_First_Slope( cs_Top, cs_Bottom, number_of_Compartments, centre_X, centre_Y, current_Slope_First_Baffle );
% %     [ bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X ] = get_Bumpy_Airfoil(  upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y,  centre_X,  centre_Y, number_of_Compartments);
% %     draw_Bumpy_Airfoil( bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X, upper_Points, Lower_Points, number_of_Compartments, current_Slope_First_Baffle );
% %     error = find_Error( bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X, cs_Middle  );
% %     error_plot_VS_angle(1,j) = error;
% %     error_plot_VS_angle(2,j) = atan(current_Slope_First_Baffle) *180/pi();
% %     if error_plot_VS_angle(2,j)< 0 % if angle is showing negative, to correct it to be between 90 and 180 degrees
% %         error_plot_VS_angle(2,j) =180 + error_plot_VS_angle(2,j);
% %     end
% %     j= j+1;
% %     
% % end
% 
% %retrieving best configuration
% current_Slope_First_Baffle = tan(current_Angle_Min_Error *pi() / 180);
% [ upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y ] = get_ALL_Points_Given_First_Slope( cs_Top, cs_Bottom, number_of_Compartments, centre_X, centre_Y, current_Slope_First_Baffle );
% [ bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X ] = get_Bumpy_Airfoil(  upper_Points, Lower_Points, radii, circle_Centres_X, circle_Centres_Y,  centre_X,  centre_Y, number_of_Compartments);
% error = find_Error( bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X, cs_Middle  );
% draw_Bumpy_Airfoil( bumpy_airfoil_Top, bumpy_Airfoil_Bottom, bumpy_Airfoil_X, upper_Points, Lower_Points, number_of_Compartments, current_Slope_First_Baffle );
% 
%  f3 = figure;
% hold off;
% plot(error_plot_VS_angle(2, :) , error_plot_VS_angle(1, :), 'o')
% hold on;
% perpendicular_first_Baffle_Angle = atan(slope_of_first_baffle) *180/pi();
% if perpendicular_first_Baffle_Angle< 0 % if angle is showing negative, to correct it to be between 90 and 180 degrees
%         perpendicular_first_Baffle_Angle = perpendicular_first_Baffle_Angle +180;     
% end
% plot([ perpendicular_first_Baffle_Angle perpendicular_first_Baffle_Angle ] , [ min(error_plot_VS_angle(1,:)) max(error_plot_VS_angle(1,:)) ] , 'r')
% title('area error V/S First baffle angle')
% drawnow

end

