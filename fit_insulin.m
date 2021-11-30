% Calls fit_Meal_Preston2015 to fit
% the insulin_A and insulin_B parameters to the
% Meal (no KCL) data from Preston et al. 2015

pars = set_params();

pars_est = [pars.insulin_A; pars.insulin_B];

lb = [0; 0];
ub = [10; 100];

fit_Meal_Preston2015(pars_est)

do_optimization = 1;
if do_optimization
    options = optimset('Display', 'iter-detailed');
    Amat = []; bvec = []; Aeq = []; beq = []; nonlcon = [];

    [pars_min, fval, exitflag, output] =...
         fmincon(@fit_Meal_Preston2015, pars_est,...
                 Amat, bvec, Aeq, beq, ...
                 lb, ub,nonlcon, options);

     fprintf('insulin_A: %f \n', pars_min(1))
     fprintf('insulin_B: %f \n', pars_min(2))
end
 
 
 % some results
%  insulin_A: 0.601825 
% insulin_B: 77.778048 

%insulin_A: 0.576538 
%insulin_B: 79.435217 

% it seems that this fit is okay... I think the main thing is the ALD, etc
% this doesn't seem like as is can be optimized much more?