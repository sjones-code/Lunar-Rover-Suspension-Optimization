function [x_u, x_l] = UpperAndLowerBoundFinder(f, t_d_max)
%UpperAndLowerBoundFinder finds the upper and lower bounds of the roots
% the function, f, when f is equal to t_d_max. The function is shifted
% vertically by t_d_max, so the bounds of roots are evaluated at this value. The
% bounds are found by iterating step evaluations of f, and when the
% starting iteration and next iteration are different values, the root must
% be between these bounds.
% Inputs: f - the function, t_d_max - Maximum Displacement Transmissibility
% Outputs: x_u - upper bounds of the roots in increasing order (1 by n matrix), x_l - lower
% bounds of the roots in increasing order (1 by n matrix)

% Created by: Stephen Jones


% Initialize output bounds
x_u = [];
x_l = [];

% Shift the function so that the "roots" are at the max t_d value which
% will allow for the algorithim to solve for the roots at f(x) = t_d_max and
% instead of at f(x) = 0
f = @(x)(f(x) - t_d_max);

% Create step size to step through the function
w_range = linspace(0, 30, 60);

% Iterate through all the steps (minus 1 because line 18 calls for ii + 1)
   for ii = 1:length(w_range)-1
       if f(w_range(ii)) > 0 && f(w_range(ii + 1)) < 0 || f(w_range(ii)) < 0 && f(w_range(ii + 1)) > 0
           
           % Save x_l and x_u if the function evaluated at these steps are opposite
           % signs
           x_l = [x_l w_range(ii)];
           x_u = [x_u w_range(ii+1)];
       end
   end
end