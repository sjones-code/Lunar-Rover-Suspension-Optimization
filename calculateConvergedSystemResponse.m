function [t, x, x_dot, F_x, E_a_list, delta_t_list] = calculateConvergedSystemResponse(m, F_spring, F_damper, freq, amp, delta_t, t_final, E_sx)
%calculateConvergedSystemResponse utilizes a coupled classical fourth order runge-kutta
% method in order to output the displacement (x) and velocity (x_dot). The
% initial time step and displacement error tolerance (E_sx) are inputted in which
% the function returns the calculations when delta_t is lowered enough
% until E_sx is satisfied.
% Inputs:   m - mass of the system
%           F_spring - spring model as a function handle
%           F_damper - damper model as a function handle
%           freq - frequency (w)
%           amp - amplitude (Y)
%           delta_t - initial time step
%           t_final - final time
%           E_sx - displacement error tolerance
% Outputs:  t - time vector
%           x - position vector
%           x_dot - velocity vector
%           F_x - total force vector
% Created by: Stephen Jones


% Create time vector by stepping with delta_t until t_final
t = 0:delta_t:t_final;

% Create function handles for the base motion and the base velocity
y = @(t)(amp*sin(freq*t)); % base motion function handle
y1 = @(t)(amp*freq*cos(freq*t)); % derivative of positon with respect to t


x0 = zeros(1, length(t)); % displacement
x0(1) = 0 - y(t(1)); % initial condition for displacement

x1 = zeros(1, length(t)); % velocity
x1(1) = 0 - y1(t(1)); % initial condition for velocity

f_vel = @(vel)(vel); % velocity function handle
f_acc = @(t, pos, vel)(((F_spring(pos - y(t)) + F_damper(vel - y1(t))))/m); % acceleration function handle

% Run a for loop of the coupled 4th order runge-kutta to then be used for
% the approximate error (E_a)
for ii = 1:length(t)-1
   pos_k1 = f_vel(x1(ii));
   vel_k1 = f_acc(t(ii), x0(ii), x1(ii));
   pos_k2 = f_vel(x1(ii) + .5*vel_k1*delta_t);
   vel_k2 = f_acc(t(ii) + delta_t*(1/2), x0(ii) + .5*pos_k1*delta_t, x1(ii) + .5*vel_k1*delta_t);
   pos_k3 = f_vel(x1(ii) + .5*vel_k2*delta_t);
   vel_k3 = f_acc(t(ii) + delta_t*(1/2), x0(ii) + .5*pos_k2*delta_t, x1(ii) + .5*vel_k2*delta_t);
   pos_k4 = f_vel(x1(ii) + vel_k3*delta_t);
   vel_k4 = f_acc(t(ii) + delta_t, x0(ii) + pos_k3*delta_t, x1(ii) + vel_k3*delta_t);
   pos_phi = (1/6)*(pos_k1 + 2*pos_k2 + 2*pos_k3 + pos_k4);
   vel_phi = (1/6)*(vel_k1 + 2*vel_k2 + 2*vel_k3 + vel_k4);
  
   x0(ii+1) = x0(ii) + pos_phi*delta_t;
   x1(ii+1) = x1(ii) + vel_phi*delta_t;
end

% Initialize respective lists
E_a = inf; % Only one set of guesses, so set to infinity
E_a_list = [];
delta_t_list = [];

% Run until the displacement error tolerance is satisfied
   while E_a >= E_sx
       % Retain previous approximations for the error calculations
       x0_old = x0;
       t_old = t;

       % Halve the time step size then re-update the time vector
       delta_t = delta_t/2;
       t = 0:delta_t:t_final;

       % Re-iterate through the coupled 4th order runge-kutta method
       for ii = 1:length(t)-1
           pos_k1 = f_vel(x1(ii));
           vel_k1 = f_acc(t(ii), x0(ii), x1(ii));
           pos_k2 = f_vel(x1(ii) + .5*vel_k1*delta_t);
           vel_k2 = f_acc(t(ii) + delta_t*(1/2), x0(ii) + .5*pos_k1*delta_t, x1(ii) + .5*vel_k1*delta_t);
           pos_k3 = f_vel(x1(ii) + .5*vel_k2*delta_t);
           vel_k3 = f_acc(t(ii) + delta_t*(1/2), x0(ii) + .5*pos_k2*delta_t, x1(ii) + .5*vel_k2*delta_t);
           pos_k4 = f_vel(x1(ii) + vel_k3*delta_t);
           vel_k4 = f_acc(t(ii) + delta_t, x0(ii) + pos_k3*delta_t, x1(ii) + vel_k3*delta_t);
  
           pos_phi = (1/6)*(pos_k1 + 2*pos_k2 + 2*pos_k3 + pos_k4);
           vel_phi = (1/6)*(vel_k1 + 2*vel_k2 + 2*vel_k3 + vel_k4);
          
           x0(ii+1) = x0(ii) + pos_phi*delta_t;
           x1(ii+1) = x1(ii) + vel_phi*delta_t;
       end
       t_mask = ismember(t,t_old); % Find matching time values
       delta_t_list(end+1) = delta_t; % update list of time step sizes
       E_a = abs(x0(t_mask) - x0_old); % list of approximate errors
       E_a = max(E_a); % finds the max of the list
       E_a_list(end+1) = max(E_a); % update list of approximate error based on time step size
   end

% Output the position and velocity vectors
x = x0;
x_dot = x1;

% Sum the spring and damper forces with the calculated position and
% velocities
F_x = F_spring(x-y(t)) + F_damper(x_dot-y1(t));

end