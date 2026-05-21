# Dynamic Systems: Lunar Rover Suspension Optimization & Numerical Simulation

An advanced numerical simulation, convergence testing, and optimization platform developed to evaluate the frequency response of a lunar rover suspension system subjected to rough terrain kinematics. This framework transitions a traditional linear mass-spring-damper assumption into realistic nonlinear component models, mapping safe frequency operating ranges to prevent structural or payload damage from displacement and force transmissibility.


---

## Engineering Problem Statement & Mission Constraints
To protect onboard sensitive electronics and camera arrays during high-velocity traversal over unstructured lunar terrains, the payload suspension must maintain rigid tracking constraints:
* **Payload Mass ($m$):** 0.5 kg
* **Maximum Allowable Displacement ($X_{max}$):** 0.0875 m (Displacement Transmissibility limit $T_{d,max} = 1.75$)
* **Maximum Allowable Transmitted Force ($F_{max}$):** 1.0 N
* **Target Operational Bandwidth:** 0.5 to 20.0 rad/s under a baseline peak terrain amplitude ($Y$) of 0.05 m.

This pipeline evaluates a benchmark **Linear System** ($k=10\text{ N/m}, c=0.5\text{ N}\cdot\text{s/m}$) against a realistic **Nonlinear System** characterized by a cubic stiffening spring ($F_{spring} = -25d^3 - 10d$) and a cubic velocity-dependent damper ($F_{damper} = 0.02v^3 - 0.42v$).

---

## Numerical Architecture & Optimization Algorithms

The mathematical simulation engine completely bypasses native solvers to execute raw, high-performance numerical analysis algorithms:

1. **Coupled Classical 4th-Order Runge-Kutta Solver ($O(h^4)$):** Solves the coupled differential state equations for position ($x$) and velocity ($\dot{x}$). Because acceleration depends nonlinearly on displacement differentials outside the base motion ($y(t) = Y\sin(\omega t)$), the state parameters are interlinked sequentially across alternating $k$-step calculations.
2. **Self-Correcting Mesh Convergence Testing:** Dynamically evaluates discretization errors. The function progressively halves the integration time step ($\Delta t$) until the maximum global error tracking differential satisfies a strict displacement tolerance threshold ($E_{s,x} = 0.001\text{ m}$).
3. **Golden Section Search Optimization:** Implements a localized Golden Section Search to locate the absolute maximum of the displacement transmissibility curve, pinpointing the damped natural frequency ($\omega_d$) within a tolerance boundary of $E_{s,\omega} = 0.01\text{ rad/s}$.
4. **Automated Root-Finding Operands:** Utilizes a custom boundary scanning algorithm paired with a secondary bisection loop to determine the exact frequencies where the non-linear displacement and force outputs cross safe thresholds, mapping the system's operational windows.

---

## Simulation Insights & Transmissibility Results

* **Displacement vs. Force Operational Trade-offs:** The optimization script successfully isolates the safe operational zones. For the nonlinear architecture, safe tracking occurs between $[0, 2.9635]\text{ rad/s}$ and $[6.4592, 20.0]\text{ rad/s}$, beyond which resonant frequencies violate structural force boundaries.
* **Nonlinear Stiffening Effects:** Numerical verification shows that the cubic stiffening elements shift the non-linear damped natural frequency upward to **$4.8455\text{ rad/s}$**, compared to the linear baseline resonance of **$4.4187\text{ rad/s}$**. This highlights the severe underestimation risks associated with purely linear assumptions in aerospace engineering tracking.

---

## Repository Structure & Core Manifest
* `Project_3_Jones.m`: Principal execution script managing data preallocation loops, plotting routines, and global orchestration.
* `calculateSystemResponse.m`: Core embedded $O(h^4)$ Runge-Kutta integration pipeline.
* `calculateConvergedSystemResponse.m`: Self-correcting iterative time-step refinement loop.
* `w_d_Optimization.m`: Golden Section Search optimization maximizer.
* `UpperAndLowerBoundFinder.m` / `t_range.m`: Boundary checking and bisection-driven root solvers.
* `CombinedOperatingRange.m`: Logical matrix comparison script resolving intersecting multi-variable boundary sets.

## Execution
To compile the architecture and regenerate the structural response curves, execute the main routine within a native MATLAB workspace:
```matlab
run('Main_Lunar_Simulation.m')
