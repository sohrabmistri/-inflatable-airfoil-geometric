function [Cy_as_Func, r_as_Func] = get_Internal_Circle_Spline_and_Radius_Equations(airfoil_Top_Equation,airfoil_Bottom_Equation)
%CREATEFIT(X_POINT,Y_POINT)
%  Create a fit.
%

%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 05-Aug-2020 18:41:07
%% Generating sets of circle Data for fitting
Cx = .02:0.01:.98;
Cy_for_Fit = [];
r_FOr_Fit = [];
for Xi  = Cx(1:end)
    [ Cy r ] = get_Tangent_Circle_Data( airfoil_Top_Equation, airfoil_Bottom_Equation, Xi );
    Cy_for_Fit = [Cy_for_Fit Cy];
    r_FOr_Fit = [r_FOr_Fit r];
end





%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( Cx, Cy_for_Fit );

% Set up fittype and options.
ft = fittype( 'poly6' );

% Fit model to data.
[Cy_as_Func, gof] = fit( xData, yData, ft );

%% Fit: 'untitled fit 2'.
[xData, yData] = prepareCurveData( Cx, r_FOr_Fit );

% Set up fittype and options.
ft = fittype( 'poly6' );

% Fit model to data.
[r_as_Func, gof] = fit( xData, yData, ft );


