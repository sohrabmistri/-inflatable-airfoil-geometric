% function rturnes the lengths of the fabrics needed to make the airfoil
% structure. 

% The front and last compartment although physically one is seperated as
% two top and bottom fabrics each
function [circular_Fabric_length_Upper,circular_Fabric_length_Lower, baffle_Length] = get_Lengths_of_Fabrics(circle_Centres_X,circle_Centres_Y, radii, upper_Points, Lower_Points)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%----------------------------------------------------------------
% appending the upper and lower points for the last point
upper_Points = [upper_Points ; (circle_Centres_X(end)+radii(end)), circle_Centres_Y(end)];
Lower_Points = [Lower_Points ; (circle_Centres_X(end)+radii(end)), circle_Centres_Y(end)];

%----------------------------------------------------------------
% appending the upper and lower points for the First point
upper_Points = [(circle_Centres_X(1)-radii(1)), circle_Centres_Y(1) ; upper_Points  ];
Lower_Points = [(circle_Centres_X(1)-radii(1)), circle_Centres_Y(1) ; Lower_Points ];

%----------------------------------------------------------------
% finding the angles subteneded by the inflatabed fabrics
%First and last fabric is devided into upper and lower
% calculating angle in cosinv of dotproduct(this always comes between 0 and
% 180 and no negatives
angles_Suptended_Upper = zeros(1,size(radii,2));
angles_Suptended_Lower = zeros(1,size(radii,2));

for i = 1:(size(radii,2))
    
    %creating vectors we need to find the angle between
    v1_Top = [(upper_Points(i+1,1) - circle_Centres_X(i)) (upper_Points(i+1,2) - circle_Centres_Y (i))]; 
    v2_Top = [(upper_Points(i,1) - circle_Centres_X(i)) (upper_Points(i,2) - circle_Centres_Y (i))];
    
    v1_Bottom = [(Lower_Points(i+1,1) - circle_Centres_X(i)) (Lower_Points(i+1,2) - circle_Centres_Y (i))]; 
    v2_Bottom = [(Lower_Points(i,1) - circle_Centres_X(i)) (Lower_Points(i,2) - circle_Centres_Y (i))];
    % converting them to unit vectors
    v1_Top      =   v1_Top/norm(v1_Top);
    v2_Top      =   v2_Top/norm(v2_Top);
    v1_Bottom   =   v1_Bottom/norm(v1_Bottom);
    v2_Bottom   =   v2_Bottom/norm(v2_Bottom);
    
    angles_Suptended_Upper(i) = acosd(dot(v1_Top,v2_Top));
    angles_Suptended_Lower(i) =  acosd(dot(v1_Bottom,v2_Bottom));
    
end

%----------------------------------------------------------------
% finding the length of circular fabrics
circular_Fabric_length_Upper = deg2rad(angles_Suptended_Upper) .* radii;
circular_Fabric_length_Lower = deg2rad(angles_Suptended_Lower) .* radii;

%% ----------------------------------------------------------------
% finding the lengths baffles
% ----------------------------------------------------------------

% ----------------------------------------------------------------
%finding length of baffles
baffle_Length = zeros(1,    size(radii,2)-1   ) ;

for i = 1:(size(radii,2) - 1)
    delx = upper_Points(i+1,1) - Lower_Points(i+1,1);
    dely = upper_Points(i+1,2) - Lower_Points(i+1,2);
    baffle_Length(i) = norm([delx dely]);
end

end

