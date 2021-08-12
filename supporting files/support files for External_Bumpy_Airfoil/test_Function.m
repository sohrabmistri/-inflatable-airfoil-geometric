
function  test_Function(  )
clc
clear
disp('gimme time in italy in hours and minutes format BRO')

H = input(' ');
M = input (' ');

disp([' you have entered ', num2str(H),':', num2str(M)])


H_I = 0;
M_I = 0 ;

M_I = 30 + M;
if M_I >= 60 
    M_I = M_I - 60;
    H_I = H + 4 + 1;
end
if M_I <= 60 
   
    H_I = H + 4;
end 
disp([' time in INDIA BRO ', num2str(H_I),':', num2str(M_I)])

end

