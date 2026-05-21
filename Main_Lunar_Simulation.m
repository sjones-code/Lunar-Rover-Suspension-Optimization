%% Main_Lunar_Simulation
% The script models the linear and non-linear systems of the springs and dampers. Functions
% are then ran to calculate the position and velocity vectors which are
% then plotted against time in the script as individual figures. Next, the
% same procedure is done with the exception of meeting a tolerance. The
% approximate error and the converged position and velocity all are plotted
% on figures in the script. Force and displacement amplitudes are
% calculated with the required functions and are plotted against frequency
% in the script. The damped natural frequency is calculated for
% displacement amplitudes of all three models: linear, nonlinear, and
% analytical (linear). Lastly, the operating ranges for all three systems
% are calculated which satisfy their respective maximums.
%
% Requires: CombinedOperatingRange.m, calculateDisplacementAmpltitude.m,
% calculateAmplitudes.m, calculateConvergedSystemResponse.m,
% UpperAndLowerBoundFinder.m, calculateSystemResponse.m, t_range.m,
% w_d_Optimization.m, calculateForceAmpltitude.m
%
% Created by: Stephen Jones


clear; clc

% System Design Parameters (Table 1)
m = 0.5; % mass (kg)
k = 10; % linear spring constant (N/m)
c = 0.5; % linear damping coefficient (N*s/m)
Y = 0.05; % maximum base amplitude (m)

%% Task 1
% Function handle of Spring Force 1
Fspring1 = @(d)(-10*d);

% Function handle of Spring Force 2
Fspring2 = @(d)(-25*(d.^3) - 10*d);

% Initialize d values for the Spring Force plot (meters)
Fs_d = linspace(-1,1,300);

% Plot Spring Force 1 and 2
   figure;
   box on; hold on;
   plot(Fs_d, Fspring1(Fs_d), 'r-', LineWidth=2.5);
   plot(Fs_d, Fspring2(Fs_d), 'g-', LineWidth=2.5);
   set(gca, 'FontSize', 10);
   xlabel('Spring Displacement, d(m)');
   ylabel('Spring Force, F_s_p_r_i_n_g(N)');
   legend('F_s_p_r_i_n_g_,_1(d) = -10d', 'F_s_p_r_i_n_g_,_2(d) = 25d^3 - 10d')
   grid on;

% Initialize d values for the Spring Force plot (meters)
Fd_v = linspace(-3,3,300);
% Function handle of Damper Force 1
Fdamper1 = @(v)(-0.50*v);
% Function handle of Damper Force 2
Fdamper2 = @(v)(0.02*(v.^3) - 0.42*v);

% Plot Damper Force 1 and 2
   figure;
   box on; hold on;
   plot(Fd_v, Fdamper1(Fd_v), 'r-', LineWidth=2.5);
   plot(Fd_v, Fdamper2(Fd_v), 'g-', LineWidth=2.5);
   set(gca, 'FontSize', 10);
   xlabel('Damper Velocity, v(m/s)');
   ylabel('Damper Force, F_d_a_m_p_e_r(N)');
   legend('F_d_a_m_p_e_r_,_1(v) = -0.50v', 'F_d_a_m_p_e_r_,_2(v) = 0.02v^3 - 0.42v')
   grid on;
   
%% Task 2

% System Model Test Settings and Initial Conditions
freq = 2; % base frequency (rad/s)
delta_t = 0.01; % time step (s)
t_final = 100; % final time (s)

% Run functions for both systems
[t, x, x_dot, F_x] = calculateSystemResponse(m, Fspring1, Fdamper1, freq, Y, delta_t, t_final);
[t2, x2, x_dot2, F_x2] = calculateSystemResponse(m, Fspring2, Fdamper2, freq, Y, delta_t, t_final);

% Create analytical solutions as function handles
y = @(t)(Y*sin(freq*t));
y1 = @(t)(Y*freq*cos(freq*t));

% Velocity vs. time plot with both systems
% figure;
% box on; hold on;
% plot(t, y1(t), 'g-', LineWidth=2.5);
% plot(t, x_dot, 'r.', LineWidth=2.5);
% plot(t2, x_dot2, 'r.', LineWidth=2.5);
% set(gca, 'FontSize', 12);
% xlabel('Velocity, v(m/s)');
% ylabel('Time (s)');
% legend('Base Velocity', 'v_l_i_n_e_a_r', 'v_n_o_n_l_i_n_e_a_r')
% grid on;

% Position vs. time plot with all systems
    figure;
    box on; hold on;
    plot(t, y(t), 'g-', LineWidth=2);
    plot(t, x, 'r.', MarkerSize=6);
    plot(t2, x2, 'b.', MarkerSize=6);
    set(gca, 'FontSize', 10);
    ylabel('Position (m)');
    xlabel('Time (s)');
    legend('Base Motion', 'x_l_i_n_e_a_r', 'x_n_o_n_l_i_n_e_a_r')
    grid on;

%% Task 3
% Initialize time step size, final time, and error tolerance
delta_t = 1; % s
t_final = 100; % s
E_s = 0.001; % error tolerance

% Run calculateConvergedSystemResponse.m functions for both systems
[t_conv1, x_conv1, x_dot_conv1, F_x_conv1, E_a1, delta_t_list1] = calculateConvergedSystemResponse(m, Fspring1, Fdamper1, freq, Y, delta_t, t_final, E_s);
[t_conv2, x_conv2, x_dot_conv2, F_x_conv2, E_a2, delta_t_list2] = calculateConvergedSystemResponse(m, Fspring2, Fdamper2, freq, Y, delta_t, t_final, E_s);

f_E_s = @(E_s)(E_s);

% Plot time sizes vs. approximate errors for both systems
    figure;
    box on; hold on;
    loglog(delta_t_list1, E_a1, 'go', delta_t_list1, E_a1, 'g--', LineWidth=2);
    loglog(delta_t_list2, E_a2, 'ro', delta_t_list2, E_a2, 'r--', LineWidth=2);
    loglog(delta_t_list1, f_E_s(delta_t_list1), 'b-', LineWidth=2)
    set(gca, 'FontSize', 10, 'Yscale', 'log', 'Xscale', 'log');
    xlabel('Time Step, ∆t (s)');
    ylabel('Approximate Error, E_a_,_x (m)');
    legend('Linear System', '','Non-linear System', '', 'Displacement Error Tolerance')
    grid on;

% Position vs. time plot with all systems
    figure;
    box on; hold on;
    plot(t, y(t), 'g-', LineWidth=2);
    plot(t_conv1, x_conv1, 'r.', MarkerSize=6);
    plot(t_conv2, x_conv2, 'b.', MarkerSize=6);
    set(gca, 'FontSize', 10);
    ylabel('Position (m)');
    xlabel('Time (s)');
    legend('Base Motion', 'Converged x_l_i_n_e_a_r', 'Converged x_n_o_n_l_i_n_e_a_r')
    grid on;

%% Task 4
% Initalize design parameters and specifications
E_sx = 0.001; % Displacement tolerance, m
t_ss = 50; % Steady-state time, s
t_final = 100; % Final time, s
w_min = 0.5; % Minimum frequency, rad/s
w_max = 20; % Maximum frequency, rad/s

% Create analytical solutions as function handles
T_d = @(w)( Y .* ( ((k.^2) + (c.*w).^2) ./ (((k - m.*(w.^2)).^2) + (c.*w).^2) ).^(0.5) ); % expected displacement
T_F = @(w)( k.*Y .* ((w./((k./m).^(0.5))).^2) .* (((k.^2) + (c.*w).^2) ./ (((k - m.*w.^2).^2) + (c.*w).^2)).^(0.5) ); % expected force amplitude

% Initalize lists/vectors
w_list = w_min:0.5:w_max; % vector of used frequencies, rad/s
X1_list = zeros(1,length(w_list)); % displacement amplitude list (spring 1)
F1_list = zeros(1,length(w_list)); % total force amplitude list (damper 1)
X2_list = zeros(1,length(w_list)); % displacement amplitude list (spring 2)
F2_list = zeros(1,length(w_list)); % total force amplitude list (damper 2)

% Iterate and run calculateAmplitudes.m to get X and F based on the
% inputted frequency for spring and damper 1
for ii = 1:length(w_list)
    freq = w_list(ii);
    [X, F] = calculateAmplitudes(m, Fspring1, Fdamper1, freq, Y, delta_t, t_final, t_ss, E_sx); % Run function
    
    % Update amplitudes
    X1_list(ii) = X;
    F1_list(ii) = F;
end

% Repeat process with new spring and damper function
for ii = 1:length(w_list)
    freq = w_list(ii);
    [X, F] = calculateAmplitudes(m, Fspring2, Fdamper2, freq, Y, delta_t, t_final, t_ss, E_sx); % Run function
    
    % Update amplitudes
    X2_list(ii) = X;
    F2_list(ii) = F;
end

% Create frequency linspace for plotting
freq_linspace = linspace(.5, 20, 300);


% Plot Displacement Amplitude figure
    figure;
    box on; hold on;
    plot(w_list, X1_list, 'go', w_list, X1_list, 'g--', LineWidth=2);
    plot(w_list, X2_list, 'ro', w_list, X2_list, 'r--', LineWidth=2);
    plot(freq_linspace, T_d(freq_linspace), 'b-', LineWidth=2.5);
    set(gca, 'FontSize', 10);
    xlabel('Frequency, w(rad/s)');
    ylabel('Displacement Amplitude (m)');
    legend('Linear System', '','Non-linear System', '','Linear Analytical System');
    grid on;

% Plot Displacement Amplitude figure
    figure;
    box on; hold on;
    plot(w_list, F1_list, 'go', w_list, F1_list, 'g--', LineWidth=2);
    plot(w_list, F2_list, 'ro', w_list, F2_list, 'r--', LineWidth=2);
    plot(freq_linspace, T_F(freq_linspace), 'b-', LineWidth=2.5);
    set(gca, 'FontSize', 10);
    xlabel('Frequency, w(rad/s)');
    ylabel('Force Amplitude (N)');
    legend('Linear System', '','Non-linear System', '','Linear Analytical System');
    grid on;

%% Task 5 
E_sw = 0.01; % Frequency tolerance, rad/s

% Calculate Damped Natural Frequency for all three systems

% Linear system
f = @(w)(calculateDisplacementAmpltitude(m, Fspring1, Fdamper1, w, Y, delta_t, t_final, t_ss, E_sx));
[w_d1] = w_d_Optimization(0.5, 20, f, E_sx);

% Non-linear system
f = @(w)(calculateDisplacementAmpltitude(m, Fspring2, Fdamper2, w, Y, delta_t, t_final, t_ss, E_sx));
[w_d2] = w_d_Optimization(0.5, 20, f, E_sx);

% Analytical Model
[w_d3] = w_d_Optimization(0.5, 20, T_d, E_sx);

%% Task 6
x_max = 0.0875; % Maximum displacement (m)
F_max = 1; % Maximum force (N)

% Define function handle with the respective system
% Find roots with UpperAndLowerBoundFinder.m
% Calculate range with t_range.m

% Define calculateDisplacementAmpltitude function handle with the linear system 
f = @(w)(calculateDisplacementAmpltitude(m, Fspring1, Fdamper1, w, Y, delta_t, t_final, t_ss, E_sx));
[x_u, x_l] = UpperAndLowerBoundFinder(f, x_max);
[td_ranges1] = t_range(f, x_u, x_l, x_max, E_sw);


% Define calculateForceAmpltitude function handle with the linear system
f = @(w)(calculateForceAmpltitude(m, Fspring1, Fdamper1, w, Y, delta_t, t_final, t_ss, E_sx));
[x_u, x_l] = UpperAndLowerBoundFinder(f, F_max);
[tf_ranges1] = t_range(f, x_u, x_l, F_max, E_sw);


% Define calculateDisplacementAmpltitude function handle with the non-linear system
f = @(w)(calculateDisplacementAmpltitude(m, Fspring2, Fdamper2, w, Y, delta_t, t_final, t_ss, E_sx));
[x_u, x_l] = UpperAndLowerBoundFinder(f, x_max);
[td_ranges2] = t_range(f, x_u, x_l, x_max, E_sw);

% Define calculateForceAmpltitude function handle with the non-linear system
f = @(w)(calculateForceAmpltitude(m, Fspring2, Fdamper2, w, Y, delta_t, t_final, t_ss, E_sx));
[x_u, x_l] = UpperAndLowerBoundFinder(f, F_max);
[tf_ranges2] = t_range(f, x_u, x_l, F_max, E_sw);

% Solve range for analytical model - Displacement model
[x_u, x_l] = UpperAndLowerBoundFinder(T_d, x_max);
[td_ranges3] = t_range(T_d, x_u, x_l, x_max, E_sw);

% Solve range for analytical model - Force model
[x_u, x_l] = UpperAndLowerBoundFinder(T_F, F_max);
[tf_ranges3] = t_range(T_F, x_u, x_l, F_max, E_sw);

% Run CombinedOperatingRange.m to solve for linear system combined range
[combined_range1] = CombinedOperatingRange(td_ranges1, tf_ranges1);

% Run CombinedOperatingRange.m to solve for non-linear system combined range
[combined_range2] = CombinedOperatingRange(td_ranges2, tf_ranges2);

% Run CombinedOperatingRange.m to solve for analytical system combined range
[combined_range3] = CombinedOperatingRange(td_ranges3, tf_ranges3);





