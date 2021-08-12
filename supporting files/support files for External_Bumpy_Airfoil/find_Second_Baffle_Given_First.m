%given first baffle upper and lower coordinates  find second baffle uppr and lower
%coordinates



function [ x1 y1 x2 y2 circle_Centres_X circle_Centres_Y radii] = find_Second_Baffle_Given_First( cs_Top, cs_Bottom, centres_X, centres_Y,upper_Points, Lower_Points, number_of_Compartments)


%Calculating for upper curve intersection****************
thetha_Lower= 70*pi()/180 ; % setting lower and uppr limits for angle of second baffle
thetha_Upper = 110*pi()/180;
thetha_Centre = (thetha_Upper+thetha_Lower)/2;


del_thetha = thetha_Upper - thetha_Lower;
hang_Check_Counter = 1;
while (del_thetha > 10^-12) && (hang_Check_Counter<150)
    % finding upper and lower intersection points of all 3 angle
    % possibilites of baffle
    [x1 y1 x2 y2] = get_Intersection_Points(cs_Top, cs_Bottom, tan(thetha_Upper), centres_X(2));
    upper_Lower_Coordinates_for_Upper_Thetha= [x1 y1 x2 y2];
    [x1 y1 x2 y2] = get_Intersection_Points(cs_Top, cs_Bottom, tan(thetha_Lower), centres_X(2));
    upper_Lower_Coordinates_for_Lower_Thetha = [x1 y1 x2 y2];
    [x1 y1 x2 y2] = get_Intersection_Points(cs_Top, cs_Bottom, tan(thetha_Centre), centres_X(2));
    upper_Lower_Coordinates_for_Centre_Thetha = [x1 y1 x2 y2];
    
    %finding all 3 possible radii and centres in order of upper lower and
    %centre
    all_3_Coordinates = [ upper_Points ; Lower_Points ; upper_Lower_Coordinates_for_Upper_Thetha(1:2) ];
    [centre_X_Upper centre_Y_Upper radii_Upper] =  get_Circle_Data_Given_3_Points( all_3_Coordinates );
    
    all_3_Coordinates = [ upper_Points ; Lower_Points ; upper_Lower_Coordinates_for_Lower_Thetha(1:2) ];
    [centre_X_Lower centre_Y_Lower radii_Lower] =  get_Circle_Data_Given_3_Points( all_3_Coordinates );   
    
      all_3_Coordinates = [ upper_Points ; Lower_Points ; upper_Lower_Coordinates_for_Centre_Thetha(1:2) ];
    [centre_X_Centre centre_Y_Centre radii_Centre] =  get_Circle_Data_Given_3_Points( all_3_Coordinates ); 
    
    %getting distace of 4th point from centre
    distance_Upper = sqrt(((centre_X_Upper - upper_Lower_Coordinates_for_Upper_Thetha(3))^2) + ((centre_Y_Upper - upper_Lower_Coordinates_for_Upper_Thetha(4))^2));
    distance_Lower = sqrt(((centre_X_Lower - upper_Lower_Coordinates_for_Lower_Thetha(3))^2) + ((centre_Y_Lower - upper_Lower_Coordinates_for_Lower_Thetha(4))^2));
    distance_Centre = sqrt(((centre_X_Centre - upper_Lower_Coordinates_for_Centre_Thetha(3))^2) + ((centre_Y_Centre - upper_Lower_Coordinates_for_Centre_Thetha(4))^2));
    
    
    % checking which side the intersection point lies

    if ((distance_Lower -radii_Lower)*(distance_Centre - radii_Centre)) <0

        thetha_Upper = thetha_Centre;
        
    elseif ((distance_Upper -radii_Upper)*(distance_Centre - radii_Centre)) <=0
        

            thetha_Lower = thetha_Centre;
            
    end
    
    
    
    del_thetha = thetha_Upper - thetha_Lower;
    thetha_Centre = (thetha_Upper+thetha_Lower)/2;
    hang_Check_Counter = hang_Check_Counter+1;
end



[x1 y1 x2 y2] = get_Intersection_Points(cs_Top, cs_Bottom, tan(thetha_Centre), centres_X(2));
circle_Centres_X = centre_X_Centre;
circle_Centres_Y = centre_Y_Centre;
radii = radii_Centre;
end

