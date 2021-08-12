
%------------------ get upper and lower intersection points of single baffle----------------
%1) pass upper_curve and lower curve, and (slope and x coordinate of line midpoint)
%2) Get point of intersection

function [x1, y1, x2, y2]= get_Intersection_Points(curve_Top, curve_Bottom, m, pnt_X)
    
% finding midpoint between upper and lower curve at given pnt_x

pnt_Y = (curve_Top(pnt_X) + curve_Bottom(pnt_X))/2;

% finding line constants given pnt_x, pnt_y
c = (pnt_Y) -(m * pnt_X);

%Calculating for upper curve intersection****************
x_Lower= max((pnt_X - .1),0); % setting lower and uppr limits for x in following search alogythm
x_Upper = min((pnt_X + .1),1);
x_Centre = (x_Upper+x_Lower)/2;


del_X = x_Upper - x_Lower;

while del_X > 10^-6
    % finding y upper, lower and middle of curve and line
    y_Lower_Curve = curve_Top(x_Lower);
    y_Upper_Curve = curve_Top(x_Upper);
    y_Centre_Curve = curve_Top(x_Centre);
    
    y_Lower_Line = (m*x_Lower) + c;
    y_Upper_Line = (m*x_Upper) + c;
    y_Centre_Line = (m*x_Centre) + c;
    
    % checking which side the intersection point lies

    if ((y_Lower_Curve-y_Lower_Line)*(y_Centre_Curve - y_Centre_Line)) <0

        x_Upper = x_Centre;
        
    elseif ((y_Upper_Curve-y_Upper_Line)*(y_Centre_Curve - y_Centre_Line)) <=0
        

            x_Lower = x_Centre;
            
    end
    
    
    
    del_X = x_Upper - x_Lower;
    x_Centre = (x_Upper+x_Lower)/2;
end

x1=x_Upper;
y1 = y_Upper_Curve;

%Calculating for Lower curve intersection****************
x_Lower= max((pnt_X - .1),0); % setting lower and uppr limits for x in following search alogythm
x_Upper = min((pnt_X + .1),1);
x_Centre = (x_Upper+x_Lower)/2;


del_X = x_Upper - x_Lower;

while del_X > 10^-6
    % finding y upper, lower and middle of curve and line
    y_Lower_Curve = curve_Bottom(x_Lower);
    y_Upper_Curve = curve_Bottom(x_Upper);
    y_Centre_Curve = curve_Bottom(x_Centre);
    
    y_Lower_Line = (m*x_Lower) + c;
    y_Upper_Line = (m*x_Upper) + c;
    y_Centre_Line = (m*x_Centre) + c;
    
    % checking which side the intersection point lies
    
    if ((y_Lower_Curve-y_Lower_Line)*(y_Centre_Curve - y_Centre_Line)) <0
        x_Upper = x_Centre;
        
    elseif ((y_Upper_Curve-y_Upper_Line)*(y_Centre_Curve - y_Centre_Line)) <=0
            x_Lower = x_Centre;
            
    end
    
    
    
    del_X = x_Upper - x_Lower;
    x_Centre = (x_Upper+x_Lower)/2; 
end
x2=x_Upper;
y2 = y_Upper_Curve;

end

% function [x1, y1, x2, y2]= get_Intersection_Points(curve_Top, curve_Bottom, m, pnt_X)
%     
% % finding midpoint between upper and lower curve at given pnt_x
% 
% pnt_Y = (curve_Top(pnt_X) + curve_Bottom(pnt_X))/2;
% 
% % finding line constants given pnt_x, pnt_y
% c = (pnt_Y) -(m * pnt_X);
% 
% %Calculating for upper curve intersection****************
% x_Lower_Indice= 1; % setting lower and uppr limits for x in following search alogythm
% x_Upper_Indice = size(curve_Top.breaks,2);
% x_Centre_Indice = round((x_Lower_Indice+x_Upper_Indice)/2);
% 
% 
% del_X_Indice = x_Upper_Indice - x_Lower_Indice;
% 
% while del_X_Indice > 1
%     % finding y upper, lower and middle of curve and line
%     y_Lower_Curve = fnval(curve_Top, curve_Top.breaks(x_Lower_Indice));
%     y_Upper_Curve = fnval(curve_Top, curve_Top.breaks(x_Upper_Indice));
%     y_Centre_Curve = fnval(curve_Top, curve_Top.breaks(x_Centre_Indice));
%     
%     y_Lower_Line = (m*curve_Top.breaks(x_Lower_Indice)) + c;
%     y_Upper_Line = (m*curve_Top.breaks(x_Upper_Indice)) + c;
%     y_Centre_Line = (m*curve_Top.breaks(x_Centre_Indice)) + c;
%     
%     % checking which side the intersection point lies
% 
%     if ((y_Lower_Curve-y_Lower_Line)*(y_Centre_Curve - y_Centre_Line)) <0
% 
%         x_Upper_Indice = x_Centre_Indice;
%         
%     elseif ((y_Upper_Curve-y_Upper_Line)*(y_Centre_Curve - y_Centre_Line)) <=0
%         
% 
%             x_Lower_Indice = x_Centre_Indice;
%             
%     end
%     
%     
%     
%     del_X_Indice = x_Upper_Indice - x_Lower_Indice;
%     x_Centre_Indice = round((x_Lower_Indice+x_Upper_Indice)/2);
% end
% 
% coefficients = curve_Top.coefs(x_Lower_Indice,:); % getting cubic coefficients of spline where intersection is occuring
% coefficients(end) = coefficients(end) - c; % solving line and cubic spline together to get new coefficeints
% coefficients(end-1) = coefficients(end-1) - m;
% x_Upper = roots(coefficients); % have got possible upper intersection points
% closeness = [0 0 0]; % to check which value is closest to the interval centre 
% for i = 1:3 % removing imaginary values
%     x_Upper(i) = x_Upper(i)* isreal(x_Upper(i));
%      closeness(i) = (x_Upper(i) - (0.5*(curve_Top.breaks(x_Lower_Indice) + curve_Top.breaks(x_Upper_Indice))))^2;
% %     if  (x_Upper(i) >= curve_Top.breaks(x_Lower_Indice)) && (x_Upper(i) <= curve_Top.breaks(x_Upper_Indice)) % getting final x1
% %         x1=x_Upper(i);
% %     end
% end
% [closest, indice] = min(closeness);
% x1 = x_Upper(indice);
% y1 = fnval(curve_Top,x1);
% 
% %Calculating for Lower curve intersection****************
% x_Lower_Indice= 1; % setting lower and uppr limits for x in following search alogythm
% x_Upper_Indice = size(curve_Bottom.breaks,2);
% x_Centre_Indice = round((x_Lower_Indice+x_Upper_Indice)/2);
% 
% 
% del_X_Indice = x_Upper_Indice - x_Lower_Indice;
% 
% while del_X_Indice > 1
%     % finding y upper, lower and middle of curve and line
%     y_Lower_Curve = fnval(curve_Bottom, curve_Bottom.breaks(x_Lower_Indice));
%     y_Upper_Curve = fnval(curve_Bottom, curve_Bottom.breaks(x_Upper_Indice));
%     y_Centre_Curve = fnval(curve_Bottom, curve_Bottom.breaks(x_Centre_Indice));
%     
%     y_Lower_Line = (m*curve_Bottom.breaks(x_Lower_Indice)) + c;
%     y_Upper_Line = (m*curve_Bottom.breaks(x_Upper_Indice)) + c;
%     y_Centre_Line = (m*curve_Bottom.breaks(x_Centre_Indice)) + c;
%     
%     % checking which side the intersection point lies
%     
%    if ((y_Lower_Curve-y_Lower_Line)*(y_Centre_Curve - y_Centre_Line)) <0
% 
%         x_Upper_Indice = x_Centre_Indice;
%         
%     elseif ((y_Upper_Curve-y_Upper_Line)*(y_Centre_Curve - y_Centre_Line)) <=0
%         
%             x_Lower_Indice = x_Centre_Indice;
%             
%     end
%     
%     
%     
%     del_X_Indice = x_Upper_Indice - x_Lower_Indice;
%     x_Centre_Indice = round((x_Lower_Indice+x_Upper_Indice)/2);
% end
% 
% coefficients = curve_Bottom.coefs(x_Lower_Indice,:); % getting cubic coefficients of spline where intersection is occuring
% coefficients(end) = coefficients(end) - c; % solving line and cubic spline together to get new coefficeints
% coefficients(end-1) = coefficients(end-1) - m;
% x_Lower = roots(coefficients) ; % have got possible upper intersection points
% closeness = [0 0 0]; % to check which value is closest to the interval centre 
% for i = 1:3 % removing imaginary values
%     x_Lower(i) = x_Lower(i)* isreal(x_Lower(i));
%     closeness(i) = (x_Lower(i) - (0.5*(curve_Bottom.breaks(x_Lower_Indice) + curve_Bottom.breaks(x_Upper_Indice))))^2;
% %     if  (x_Lower(i) >= curve_Bottom.breaks(x_Lower_Indice)) && (x_Lower(i) <= curve_Bottom.breaks(x_Upper_Indice)) % getting final x1
% %         x2 = x_Lower(i);
% %     end
% end
% [closest, indice] = min(closeness);
% x2 = x_Lower(indice);
% 
% y2 = fnval(curve_Bottom,x2);
% 
% end