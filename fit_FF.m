% This can be used to fit the FF parameter with the KCL only
% experiment from Preston et al 2015
% uses fit_KCL_Preston2015

pars = set_params();

FF_est = [0.1];

lb = [0];
ub = [7];

start_res = fit_KCL_Preston2015(FF_est);
fprintf('starting residual %f \n', start_res)

do_optimization = 1;
if do_optimization
    options = optimset('Display', 'iter-detailed');
    Amat = []; bvec = []; Aeq = []; beq = []; nonlcon = [];

    [pars_min, fval, exitflag, output] =...
         fmincon(@fit_KCL_Preston2015, FF_est,...
                 Amat, bvec, Aeq, beq, ...
                 lb, ub,nonlcon, options);

     fprintf('FF: %f \n', pars_min(1))
end