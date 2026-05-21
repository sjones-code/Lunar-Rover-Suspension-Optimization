function [w] = calculateDisplacementAmpltitude(m, F_spring, F_damper, freq, amp, delta_t, t_final, t_ss, E_sx)
%calculateAmplitude finds the displacement amplitude of the
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
% Outputs:  X - displacement amplitude
% Requires: calculateConvergedSystemResponse.m
% Created by: Stephen Jones


% Run calculateConvergedSystemResponse.m to get x and x_dot vectors
[t, x] = calculateConvergedSystemResponse(m, F_spring, F_damper, freq, amp, delta_t, t_final, E_sx);

% Create a mask when the time is equal to or greater than the steady-state
% time
t_mask = t >= t_ss;

% Apply mask to the position and velocity vectors
x_masked = x(t_mask);

% Use the masked vectors to calculate function outputs
w = (max(x_masked)- min(x_masked))/2;


end