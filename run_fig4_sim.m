% This file runs and then plots two simulations based on given input
% for each of the simulations
close all

%% simulation 1
pars1 = set_params();

Kin1.Kin_type = 'long_simulation'; 
Kin1.Meal = 1;
Kin1.KCL = 1;

MealInfo1.t_breakfast = 7; % enter the hour at which to have breakfast in 24 hour format: for ex: 0 = midnight, 8 = 8am, 15 = 3pm
MealInfo1.t_lunch = 13;    % break between mealtimes has to be more than 6 hours for the C_insulin function to work properly
MealInfo1.t_dinner = 19;
MealInfo1.K_amount = 35/3;  % how much K is ingested PER MEAL 3 times a day
MealInfo1.meal_type = 'Figure 4';

alt_sim1 = true; %false;
do_ins = 1;
do_FF = 1;

alt_sim1 = true; %false;
do_ALD_NKA1 =true;
do_ALD_sec1 = true;
urine = true;

MKX_type = 3; %0 if not doing MK cross talk, 1:dtKsec, 2:cdKsec,  3:cdKreab
MKX_slope = 0.1; % should be -0.1 for cdKreab

if MKX_type
    IG_file1 = './IGdata/KregSS_MK.mat';
else
    IG_file1 = './IGdata/KregSS.mat';
end

days = 20; % number of days to run the simulation for
opts = odeset('MaxStep', 20);
x0 = SSdata1;
x_p0 = zeros(size(SSdata1));
t0 = 0;
tf = days*1440; %+ pars1.tchange;%1*1440 + pars1.tchange;
tspan = t0:0.5:tf;

%% this is for when the MK Xtalk is off
% % get SS intial condition
% disp('get sim 1 SS')
% % IG_file1 = './IGdata/KregSS.mat';
% disp('1')
% [SSdata1, exitflag1, residual1] = getSS(IG_file1, pars1, Kin1, ...
%                                             'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B],...
%                                            'do_FF', [do_FF, pars1.FF],...
%                                            'alt_sim',alt_sim1,...
%                                            'do_M_K_crosstalk', [MKX_type, MKX_slope],...
%                                            'MealInfo', {MealInfo1.t_breakfast, MealInfo1.t_lunch, MealInfo1.t_dinner,...
%                                                         MealInfo1.K_amount,MealInfo1.meal_type});
% disp('2')
% if exitflag1 <=0
%     disp('residuals')
%     disp(residual1)
% end
% disp('sim 1 SS finished')
% 
% % run simulation 1
% 
% disp('start simulation 1')
% %[x0,x_p0] = decic(@(t,x,x_p) k_reg_mod(t,x,x_p, pars1, ...
% %                                'Kin_type', {Kin1.Kin_type, Kin1.Meal, Kin1.KCL}, ...
% %                                'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B],...
% %                                'do_FF', [do_FF, pars1.FF]), ...
% %                tspan, x0, [], x_p0, [], opts);
% disp('decic done')
% [T1,X1] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars1, ...
%                                 'Kin_type', {Kin1.Kin_type, Kin1.Meal, Kin1.KCL}, ...
%                                 'alt_sim', alt_sim1, ...
%                                 'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B],...
%                                 'do_FF', [do_FF, pars1.FF],...
%                                 'do_M_K_crosstalk', [MKX_type, MKX_slope],...
%                                 'MealInfo', {MealInfo1.t_breakfast, MealInfo1.t_lunch, MealInfo1.t_dinner,...
%                                                         MealInfo1.K_amount, MealInfo1.meal_type}), ...
%                             tspan, x0, x_p0, opts);
% disp('simulation 1 finished')


%% and this is if MK Xtalk is on
% get SS intitial condition
[SSdata1, exitflag1, residual1] = getSS(IG_file1, pars1, Kin1,...
                                'alt_sim',alt_sim1, ...
                                'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B], ...
                                'do_ALD_NKA', do_ALD_NKA1,...
                                'do_ALD_sec', do_ALD_sec1, ...
                                'do_FF', [do_FF, pars1.FF], ...
                                'do_M_K_crosstalk', [MKX_type, MKX_slope],...
                                'urine',urine,...
                                'MealInfo', {MealInfo1.t_breakfast, MealInfo1.t_lunch, MealInfo1.t_dinner,...
                                                        MealInfo1.K_amount, MealInfo1.meal_type});  

if exitflag1 <= 0
    disp(residual1)
end

% run simulation 1
x0 = SSdata1;
x_p0 = zeros(size(SSdata1));
%fprintf('length of x_p0 %d \n', length(x_p0))

disp('start simulation 1')
%[x0,x_p0] = decic(@(t,x,x_p) k_reg_mod(t,x,x_p, pars1, ...
%                                'Kin_type', {Kin1.Kin_type, Kin1.Meal, Kin1.KCL}, ...
%                                'alt_sim', alt_sim1, ...
%                                'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B], ...
%                                'do_ALD_NKA', do_ALD_NKA1,...
%                                'do_ALD_sec', do_ALD_sec1, ...
%                                'do_FF', [do_FF, pars1.FF],...
%                                'do_M_K_crosstalk', [MKX_type, MKX_slope],...
%                                'urine',urine), ...
%                tspan, x0, [], x_p0, [], opts);
                                
disp('decic done')
[T1,X1] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars1, ...
                                'Kin_type', {Kin1.Kin_type, Kin1.Meal, Kin1.KCL}, ...
                                'alt_sim', alt_sim1, ...
                                'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B], ...
                                'do_ALD_NKA', do_ALD_NKA1,...
                                'do_ALD_sec', do_ALD_sec1, ...
                                'do_FF', [do_FF, pars1.FF],...
                                'do_M_K_crosstalk', [MKX_type, MKX_slope],...
                                'urine',urine,...
                                'MealInfo', {MealInfo1.t_breakfast, MealInfo1.t_lunch, MealInfo1.t_dinner,...
                                                        MealInfo1.K_amount, MealInfo1.meal_type}), ...
                            tspan, x0, x_p0, opts);

disp('simulation 1 finished')



%% simulation 2
disp('get sim 2 SS')
pars2 = set_params();

Kin2.Kin_type = 'long_simulation';%'gut_Kin';%'Preston_SS';
Kin2.Meal = 1;
Kin2.KCL = 1;

MealInfo2.t_breakfast = 7; % enter the hour at which to have breakfast in 24 hour format: for ex: 0 = midnight, 8 = 8am, 15 = 3pm
MealInfo2.t_lunch = 13;    % break between mealtimes has to be more than 6 hours for the C_insulin function to work properly
MealInfo2.t_dinner = 19;
MealInfo2.K_amount = 35/3;
MealInfo2.meal_type = 'Figure 4';


alt_sim2 = true; %false;
do_ALD_NKA2 =true;
do_ALD_sec2 = true;
urine = true;

do_ins = 1;
do_FF = 1;

MKX_type = 1; %0 if not doing MK cross talk, 1:dtKsec, 2:cdKsec,  3:cdKreab
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
                                'do_M_K_crosstalk', [MKX_type, MKX_slope],...
                                'urine',urine,...
                                'MealInfo', {MealInfo2.t_breakfast, MealInfo2.t_lunch, MealInfo2.t_dinner,...
                                                        MealInfo2.K_amount, MealInfo2.meal_type});  

if exitflag2 <= 0
    disp(residual2)
end

% run simulation 2
x0 = SSdata2;
x_p0 = zeros(size(SSdata2));
%fprintf('length of x_p0 %d \n', length(x_p0))

disp('start simulation 2')
%[x0,x_p0] = decic(@(t,x,x_p) k_reg_mod(t,x,x_p, pars2, ...
%                                'Kin_type', {Kin2.Kin_type, Kin2.Meal, Kin2.KCL}, ...
%                                'alt_sim', alt_sim2, ...
%                                'do_insulin', [do_ins, pars2.insulin_A, pars2.insulin_B], ...
%                                'do_ALD_NKA', do_ALD_NKA2,...
%                                'do_ALD_sec', do_ALD_sec2, ...
%                                'do_FF', [do_FF, pars2.FF],...
%                                'do_M_K_crosstalk', [MKX_type, MKX_slope],...
%                                'urine',urine), ...
%                tspan, x0, [], x_p0, [], opts);
                                
disp('decic done')
[T2,X2] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars2, ...
                                'Kin_type', {Kin2.Kin_type, Kin2.Meal, Kin2.KCL}, ...
                                'alt_sim', alt_sim2, ...
                                'do_insulin', [do_ins, pars2.insulin_A, pars2.insulin_B], ...
                                'do_ALD_NKA', do_ALD_NKA2,...
                                'do_ALD_sec', do_ALD_sec2, ...
                                'do_FF', [do_FF, pars2.FF],...
                                'do_M_K_crosstalk', [MKX_type, MKX_slope],...
                                'urine',urine,...
                                'MealInfo', {MealInfo2.t_breakfast, MealInfo2.t_lunch, MealInfo2.t_dinner,...
                                                        MealInfo2.K_amount, MealInfo2.meal_type}), ...
                            tspan, x0, x_p0, opts);

disp('simulation 2 finished')


%% simulation 3
disp('get sim 3 SS')
pars3 = set_params();

Kin3.Kin_type = 'long_simulation';%'gut_Kin';%'Preston_SS';
Kin3.Meal = 1;
Kin3.KCL = 1;

MealInfo3.t_breakfast = 7; % enter the hour at which to have breakfast in 24 hour format: for ex: 0 = midnight, 8 = 8am, 15 = 3pm
MealInfo3.t_lunch = 13;    % break between mealtimes has to be more than 6 hours for the C_insulin function to work properly
MealInfo3.t_dinner = 19;
MealInfo3.K_amount = 35/3;
MealInfo3.meal_type = 'Figure 4';


alt_sim3 = true; %false;
do_ALD_NKA3 =true;
do_ALD_sec3 = true;
urine = true;

do_ins = 1;
do_FF = 1;

MKX_type = 2; %0 if not doing MK cross talk, 1:dtKsec, 2:cdKsec,  3:cdKreab
MKX_slope = 0.1; % should be -0.1 for cdKreab

if MKX_type
    IG_file3 = './IGdata/KregSS_MK.mat';
else
    IG_file3 = './IGdata/KregSS.mat';
end

% get SS intitial condition
[SSdata3, exitflag3, residual3] = getSS(IG_file3, pars3, Kin3,...
                                'alt_sim',alt_sim3, ...
                                'do_insulin', [do_ins, pars3.insulin_A, pars3.insulin_B], ...
                                'do_ALD_NKA', do_ALD_NKA3,...
                                'do_ALD_sec', do_ALD_sec3, ...
                                'do_FF', [do_FF, pars3.FF], ...
                                'do_M_K_crosstalk', [MKX_type, MKX_slope],...
                                'urine',urine,...
                                'MealInfo', {MealInfo3.t_breakfast, MealInfo3.t_lunch, MealInfo3.t_dinner,...
                                                        MealInfo3.K_amount, MealInfo3.meal_type});  

if exitflag3 <= 0
    disp(residual3)
end

% run simulation 3
x0 = SSdata3;
x_p0 = zeros(size(SSdata3));
%fprintf('length of x_p0 %d \n', length(x_p0))

disp('start simulation 3')
%[x0,x_p0] = decic(@(t,x,x_p) k_reg_mod(t,x,x_p, pars3, ...
%                                'Kin_type', {Kin3.Kin_type, Kin3.Meal, Kin3.KCL}, ...
%                                'alt_sim', alt_sim3, ...
%                                'do_insulin', [do_ins, pars3.insulin_A, pars3.insulin_B], ...
%                                'do_ALD_NKA', do_ALD_NKA3,...
%                                'do_ALD_sec', do_ALD_sec3, ...
%                                'do_FF', [do_FF, pars3.FF],...
%                                'do_M_K_crosstalk', [MKX_type, MKX_slope],...
%                                'urine',urine), ...
%                tspan, x0, [], x_p0, [], opts);
                                
disp('decic done')
[T3,X3] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars3, ...
                                'Kin_type', {Kin3.Kin_type, Kin3.Meal, Kin3.KCL}, ...
                                'alt_sim', alt_sim3, ...
                                'do_insulin', [do_ins, pars3.insulin_A, pars3.insulin_B], ...
                                'do_ALD_NKA', do_ALD_NKA3,...
                                'do_ALD_sec', do_ALD_sec3, ...
                                'do_FF', [do_FF, pars3.FF],...
                                'do_M_K_crosstalk', [MKX_type, MKX_slope],...
                                'urine',urine,...
                                'MealInfo', {MealInfo3.t_breakfast, MealInfo3.t_lunch, MealInfo3.t_dinner,...
                                                        MealInfo3.K_amount, MealInfo3.meal_type}), ...
                            tspan, x0, x_p0, opts);

disp('simulation 3 finished')



%% plot simulation
do_plt = 1;
if do_plt
    clear params T X
    disp('**plotting simulation results**')
    Kin_opts{1} = Kin1;
    Kin_opts{2} = Kin2;
    Kin_opts{3} = Kin3;
    MealInfo{1} = MealInfo1;
    MealInfo{2} = MealInfo2;
    MealInfo{3} = MealInfo3;
    params{1} = pars1;
    params{2} = pars2;
    params{3} = pars3;
    T{1} = T1;
    T{2} = T2;
    T{3} = T3;
    X{1} = X1;
    X{2} = X2;
    X{3} = X3;
    labels{1} = 'CD reabsorption K^+ crosstalk';  % sim 1
    labels{2} = 'DT secretion K^+ crosstalk';    % sim 2
    labels{3} = 'CD secretion K^+ crosstalk';    % sim 3
    plot_fig4_sim(T,X, params, Kin_opts, labels, tf, MealInfo, days)
end