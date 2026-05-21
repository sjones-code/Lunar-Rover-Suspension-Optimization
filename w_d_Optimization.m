function [x_r] = w_d_Optimization(x_l, x_u, f, e_s)
%w_d_Optimization uses the Golden Section Search to approximate the
% maximum of the input function, f, given the lower and upper bounds.
% Inputs: x_l - the lower bound, x_u - the upper bound, f - the function
% containing the maximum given as a function handle, e_s - Frequency tolerance
% Output: x_r - approximation of the maximum
% Created by: Stephen Jones

% Initialize variables and constants that will be used in each iteration
R = (sqrt(5) - 1)/2; % Approximately 0.61803
d = (R*x_u) - (R*x_l);
x_1 = x_u - d;
x_2 = x_l + d;
e_a = 100;

% Run while loop until e_a is less than (satisfies) the percent error tolerance
% Recalculates either x_1 or x_2 each iteration
% Reevaluates and compares f(x_l) and f(x_u) each iteration
    while abs(e_a) >= e_s
        if f(x_l) > f(x_u)
            x_r = x_1;
            x_u = x_2;
            x_2 = x_1;
            x_1 = x_u - R * (x_u - x_l);
        else
            x_r = x_2;
            x_l = x_1;
            x_1 = x_2;
            x_2 = x_l + R * (x_u - x_l);
        end
        e_a = (1 - R) * abs((x_u - x_l));
        
    end

end