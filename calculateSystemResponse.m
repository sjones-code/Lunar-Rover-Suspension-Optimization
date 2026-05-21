function [t, x, x_dot, F_x] = calculateSystemResponse(m, F_spring, F_damper, freq, amp, delta_t, t_final)
%calculateSystemResponse utilizes a coupled classical fourth order runge-kutta
% method in order to output the displacement (x) and velocity (x_dot). The
% function calculates these outputs using delta_t (time step size) through
% t_final.
% Inputs:   m - mass of the system
%           F_spring - spring model as a function handle
%           F_damper - damper model as a function handle
%           freq - frequency (w)
%           amp - amplitude (Y)
%           delta_t - time step
%           t_final - final time
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

% Initialize displacement and velocity vectors
x0 = zeros(1, length(t)); % displacement vector
x0(1) = 0 - y(t(1)); % initial condition for displacement

x1 = zeros(1, length(t)); % velocity vector
x1(1) = 0; % initial condition for velocity

f_vel = @(vel)(vel); % velocity function handle
f_acc = @(t, pos, vel)(((F_spring(pos - y(t)) + F_damper(vel - y1(t))))/m); % acceleration function handle

   for ii = 1:length(t)-1
       % Alternate position and velocity k values
       pos_k1 = f_vel(x1(ii));
       vel_k1 = f_acc(t(ii), x0(ii), x1(ii));
       pos_k2 = f_vel(x1(ii) + .5*vel_k1*delta_t);
       vel_k2 = f_acc(t(ii) + delta_t*(1/2), x0(ii) + .5*pos_k1*delta_t, x1(ii) + .5*vel_k1*delta_t);
       pos_k3 = f_vel(x1(ii) + .5*vel_k2*delta_t);
       vel_k3 = f_acc(t(ii) + delta_t*(1/2), x0(ii) + .5*pos_k2*delta_t, x1(ii) + .5*vel_k2*delta_t);
       pos_k4 = f_vel(x1(ii) + vel_k3*delta_t);
       vel_k4 = f_acc(t(ii) + delta_t, x0(ii) + pos_k3*delta_t, x1(ii) + vel_k3*delta_t);

       % Update phi values for position and velocity
       pos_phi = (1/6)*(pos_k1 + 2*pos_k2 + 2*pos_k3 + pos_k4);
       vel_phi = (1/6)*(vel_k1 + 2*vel_k2 + 2*vel_k3 + vel_k4);
      
       % Update next values in the position and velocity vectors
       x0(ii+1) = x0(ii) + pos_phi*delta_t;
       x1(ii+1) = x1(ii) + vel_phi*delta_t;
   end

% Output the position and velocity vectors
x = x0;
x_dot = x1;

% Sum the spring and damper forces with the calculated position and
% velocities
F_x = F_spring(x-y(t)) + F_damper(x_dot-y1(t));

end

