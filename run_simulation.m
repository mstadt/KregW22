% This file runs and then plots two simulations based on given input
% for each of the simulations

%% simulation 1
pars1 = set_params();

Kin1.Kin_type = 'gut_Kin'; 
Kin1.Meal = 0;
Kin1.KCL = 1;

do_ins = 0;
do_FF = 1;

% get SS intial condition
disp('get sim 1 SS')
IG_file1 = './IGdata/KregSS.mat';
[SSdata1, exitflag1, residual1] = getSS(IG_file1, pars1, Kin1, ...
                                            'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B],...
                                           'do_FF', [do_FF, pars1.FF]);
if exitflag1 <=0
    disp('residuals')
    disp(residual1)
end
disp('sim 1 SS finished')

% run simulation 1
opts = odeset('MaxStep', 20);
x0 = SSdata1;
x_p0 = zeros(size(SSdata1));
t0 = 0;
tf = 1*1440 + pars1.tchange;%1*1440 + pars1.tchange;
tspan = t0:0.5:tf;

disp('start simulation 1')
[T1,X1] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars1, ...
                                'Kin_type', {Kin1.Kin_type, Kin1.Meal, Kin1.KCL}, ...
                                'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B],...
                                'do_FF', [do_FF, pars1.FF]), ...
                        tspan, x0, x_p0, opts);
disp('simulation 1 finished')

%% simulation 2
disp('get sim 2 SS')
pars2 = set_params();

Kin2.Kin_type = 'gut_Kin';%'Preston_SS';
Kin2.Meal = 0;
Kin2.KCL = 1;

alt_sim2 =false;
do_ALD_NKA2 =true;
do_ALD_sec2 = true;

do_ins = 0;
do_FF = 1;

MKX_type = 0; %0 if not doing MK cross talk, 1:dtKsec, 2:cdKsec,  3:cdKreab
MKX_slope = 0.1; % should be -0.1 for cdKreab

if MKX_type
    IG_file2 = './IGdata/KregSS_MK.mat';
else
    IG_file2 = './IGdata/KregSS.mat';
end

% get SS intitial condition
[SSdata2, exitflag2, residual2] = getSS(IG_file2, pars2, Kin2,...
                                'alt_sim',alt_sim2, ...
                                'do_insulin', [do_ins, pars2.insulin_A, pars2.insulin_B], ...
                                'do_ALD_NKA', do_ALD_NKA2,...
                                'do_ALD_sec', do_ALD_sec2, ...
                                'do_FF', [do_FF, pars2.FF], ...
                                'do_M_K_crosstalk', [MKX_type, MKX_slope]);
if exitflag2 <= 0
    disp(residual2)
end

% run simulation 2
x0 = SSdata2;
x_p0 = zeros(size(SSdata2));

disp('start simulation 2')
[T2,X2] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars2, ...
                                'Kin_type', {Kin2.Kin_type, Kin2.Meal, Kin2.KCL}, ...
                                'alt_sim', alt_sim2, ...
                                'do_insulin', [do_ins, pars2.insulin_A, pars2.insulin_B], ...
                                'do_ALD_NKA', do_ALD_NKA2,...
                                'do_ALD_sec', do_ALD_sec2, ...
                                'do_FF', [do_FF, pars2.FF],...
                                'do_M_K_crosstalk', [MKX_type, MKX_slope]), ...
                tspan, x0, x_p0, opts);
disp('simulation 2 finished')

%% plot simulation
do_plt = 1;
if do_plt
    clear params T X
    disp('**plotting simulation results**')
    Kin_opts{1} = Kin1;
    Kin_opts{2} = Kin2;
    params{1} = pars1;
    params{2} = pars2;
    T{1} = T1;
    T{2} = T2;
    X{1} = X1;
    X{2} = X2;
    labels{1} = 'original simulation';
    labels{2} = 'simulation 2';
    plot_simulation(T,X, params, Kin_opts, labels, tf)
end
