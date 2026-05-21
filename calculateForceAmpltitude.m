function [F] = calculateForceAmpltitude(m, F_spring, F_damper, freq, amp, delta_t, t_final, t_ss, E_sx)
%calculateForceAmplitude finds the total force amplitude of the
% inputted systems when the solution has reached steady-state (t_ss). 
% Inputs:   m - mass of the system
%           F_spring - spring model as a function handle
%           F_damper - damper model as a function handle
%           freq - frequency (w)
%           amp - amplitude (Y)
%           delta_t - initial time step
%           t_final - final time
%           t_ss - steady-state time
%           E_sx - displacement error tolerance
% Outputs:  F - total force amplitude
% Requires: calculateConvergedSystemResponse.m
% Created by: Stephen Jones

% Run calculateConvergedSystemResponse.m to get x and x_dot vectors
[t, ~, ~, F_x] = calculateConvergedSystemResponse(m, F_spring, F_damper, freq, amp, delta_t, t_final, E_sx);

% Create a mask when the time is equal to or greater than the steady-state
% time
t_mask = t >= t_ss;

% Output total force amplitude
F = (max(F_x(t_mask))- min(F_x(t_mask)))/2;

end