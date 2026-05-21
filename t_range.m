function [ranges] = t_range(f, x_u, x_l, t_max, e_s)
%t_range returns the output, ranges, which is where the inputted function,
% f, operates under the t_max value. The function is shifted
% vertically by t_max, so the roots are evaluated at this value. Then, the
% bisection method is ran based on the number of roots. 
% Inputs: f - the function, x_u - upper bounds (1 by n matrix), x_l -
% lower bounds (1 by n matrix), t_max - max transmissibility, e_s -
% frequency tolerance
% Output: ranges - min and max frequencies along with calculated roots in
% ascending order (1 by n matrix)
% Created by: Stephen Jones

% Shift the function so that the "roots" are at the max t_d value which
% will allow for the algorithim to solve for the roots at f(x) = t_d_max and
% instead of at f(x) = 0
f = @(x)(f(x) - t_max);

% Each upper bound has a corresponding root, so number of upper (or lower
% bounds) means that same number of roots
num_of_roots = length(x_u);

% Looking at the graphs/table, only options for the number of roots are
% either 0, 1, or 2
   % When there are 2 roots, run through bisection method on both roots
   if num_of_roots == 2
       x_r = zeros(1,2);
       old_x_r = x_r;
       for ii = 1:2
           % Calculate x_r
           x_r(ii) = (x_l(ii) + x_u(ii)) ./ 2;
          
           % e_a is undefined for the first iteration, so set to high number (100)
           e_a = 100;
          
           % Iterate until percent error tolerance is satisfied
           % Recalculate x_r and e_a in each iteration
           while abs(e_a) >= e_s
               if f(x_l(ii))*f(x_r(ii)) > 0
                   x_l(ii) = x_r(ii);
               else
                   x_u(ii) = x_r(ii);
               end
      
               old_x_r(ii) = x_r(ii);
               x_r(ii) = (x_l(ii) + x_u(ii)) ./ 2;
               e_a = (x_r(ii) - old_x_r(ii)) ;
           end
       end
       ranges = [0 x_r 20]; % Roots will always be between the 0, 30 bounds (shown/proven by the graphs)
   
   % When there is one root only, run through bisection method for just the
   % one root
   elseif num_of_roots == 1
       x_r = 0;
       old_x_r = x_r;
       % Calculate x_r
       x_r = (x_l + x_u) ./ 2;
       % e_a is undefined for the first iteration, so set to high number (100)
       e_a = 100;
       % Iterate until percent error tolerance is satisfied
       % Recalculate x_r and e_a in each iteration
       while abs(e_a) >= e_s
           if f(x_l)*f(x_r) > 0
               x_l = x_r;
           else
               x_u = x_r;
           end
           old_x_r = x_r;
           x_r = (x_l + x_u) ./ 2;
           e_a = (x_r - old_x_r);
       end
       ranges = [0 x_r]; % All instances have the root start after f(0) (found from graphs), so 0 will always be a starting bound

   % When there is no roots
   else
       ranges = [0 20]; % No roots, so the bounds are just from 0 to 20
   end
end

