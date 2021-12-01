# KregW22

Code files for K+ regulation model.

## Key files

**checkIC.m** uses MATLAB function decic to check if the initial condition is consistent

**fit_FF.m** fit the FF parameter to the KCL only data, calls **fit_KCL_Preston2015**

**fit_insulin.m** fit insulin_A and insulin_B parameters to the Meal only data, calls **fit_Meal_Preston2015**

**run_getSS.m** calls **getSS** which computes the steady state of the given system

**k_reg_mod** model equations

**run_Preston_exp** runs the Meal only, KCL only and Meal+KCL only simulations and then plots relevant results using **plot_Preston_exp**

**run_simulation** runs 2 simulations based on given specifications, plots relevant results using **plot_simulation**

### Data/
contains data file from Preston et al. 2015
data file is generated from makePrestonData.m

### IGdata/
data for initial guesses

### fitting_eqns
files for investigating other functions in devlopment


