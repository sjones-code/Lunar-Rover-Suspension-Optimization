function [combined_range] = CombinedOperatingRange(t_d_ranges, t_f_ranges)
%CombinedOperatingRange combines the ranges of the T_d and T_f ranges by
% summing the number of total bounds and then comparing the first and third
% bounds (1st/3rd are x_l bounds) and second and forth bounds (2nd/4th are
% x_u bounds) in a certain order/amount based on the total number of bounds
% from the inputs. The output, combined_range, is a matrix that contains
% the overlaps between the two input ranges.
% Inputs: t_d_ranges - x values of the T_d function which are below the
% max displacement transmissibility, t_f_ranges - x values of the T_f function which are below the
% max force transmissibility
% Outputs: combined_range - (n by 2 matrix) where both of the inputted
% ranges overlap and each row are its own beginning/ending bounds
% Created by: Stephen Jones

% Finds the number of bounds of both of the ranges
d_length = length(t_d_ranges);
f_length = length(t_f_ranges);

% Number of bounds determine the process of how each bound is compared to
% each other and then combined to form the output. Either 2, 3, or 4 sets
% of bounds (4, 6, 8 bounds respectively) which is found from the table.



% If there are 8 bounds, then compare with this method:
if d_length + f_length == 8
   combined_range = zeros(2,2); % 2x2 matrix since output will be 2 sets of bounds
   if t_d_ranges(1) >= t_f_ranges(1)
       combined_range(1) = t_d_ranges(1);
   elseif t_d_ranges(1) <= t_f_ranges(1)
       combined_range(1) = t_f_ranges(1);
   end
   if t_d_ranges(3) >= t_f_ranges(3)
       combined_range(2) = t_d_ranges(3);
   elseif t_d_ranges(3) <= t_f_ranges(3)
       combined_range(2) = t_f_ranges(3);
   end
   if t_d_ranges(2) <= t_f_ranges(2)
       combined_range(3) = t_d_ranges(2);
   elseif t_d_ranges(2) >= t_f_ranges(2)
       combined_range(3) = t_f_ranges(2);
   end
   if t_d_ranges(4) >= t_f_ranges(4)
       combined_range(4) = t_d_ranges(4);
   elseif t_d_ranges(4) <= t_f_ranges(4)
       combined_range(4) = t_f_ranges(4);
   end
  
end

% If there are 4 bounds, then compare with this method:
if d_length + f_length == 4
   combined_range = zeros(1,2); % Will only be one pair of bounds as output (1x2 matrix)
   if t_d_ranges(1) >= t_f_ranges(1)
       combined_range(1) = t_d_ranges(1);
   elseif t_d_ranges(1) <= t_f_ranges(1)
       combined_range(1) = t_f_ranges(1);
   end
   if t_d_ranges(2) <= t_f_ranges(2)
       combined_range(2) = t_d_ranges(2);
   elseif t_d_ranges(2) >= t_f_ranges(2)
       combined_range(2) = t_f_ranges(2);
   end
end

% If there are 6 bounds, then compare with this method:
if d_length + f_length == 6 % 2x2 matrix since output will be 2 sets of bounds
   combined_range = zeros(2,2);
   if t_d_ranges(1) >= t_f_ranges(1)
       combined_range(1) = t_d_ranges(1);
   elseif t_d_ranges(1) <= t_f_ranges(1)
       combined_range(1) = t_f_ranges(1);
   end
   if t_d_ranges(3) >= t_f_ranges(1)
       combined_range(2) = t_d_ranges(3);
   elseif t_d_ranges(3) <= t_f_ranges(1)
       combined_range(2) = t_f_ranges(1);
   end
   if t_d_ranges(2) <= t_f_ranges(2)
       combined_range(3) = t_d_ranges(2);
   elseif t_d_ranges(2) >= t_f_ranges(2)
       combined_range(3) = t_f_ranges(2);
   end
   if t_d_ranges(4) <= t_f_ranges(2)
       combined_range(4) = t_d_ranges(4);
   elseif t_d_ranges(4) >= t_f_ranges(2)
       combined_range(4) = t_f_ranges(2);
   end
end
end