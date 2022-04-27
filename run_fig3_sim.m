% This file runs and then plots two simulations based on given input
% for each of the simulations
close all
clear all

%% simulation 1
pars1 = set_params();

Kin1.Kin_type = 'long_simulation'; 
Kin1.Meal = 1;
Kin1.KCL = 1;


MealInfo1.t_breakfast = 7; % enter the hour at which to have breakfast in 24 hour format: for ex: 0 = midnight, 8 = 8am, 15 = 3pm
MealInfo1.t_lunch = 13;    % break between mealtimes has to be more than 6 hours for the C_insulin function to work properly
MealInfo1.t_dinner = 19;
MealInfo1.K_amount = 120/3;  % how much K is ingested PER MEAL 3 times a day
MealInfo1.meal_type = 'Figure 3';


alt_sim1 = true; %false;
do_ins = 1;
do_FF = 1;

% get SS intial condition
disp('get sim 1 SS')
IG_file1 = './IGdata/KregSS.mat';
disp('1')
[SSdata1, exitflag1, residual1] = getSS(IG_file1, pars1, Kin1, ...
                                            'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B],...
                                           'do_FF', [do_FF, pars1.FF],...
                                           'alt_sim',alt_sim1,...
                                           'MealInfo', {MealInfo1.t_breakfast, MealInfo1.t_lunch, MealInfo1.t_dinner,...
                                                        MealInfo1.K_amount, MealInfo1.meal_type});
disp('2')
if exitflag1 <=0
    disp('residuals')
    disp(residual1)
end
disp('sim 1 SS finished')

% run simulation 1
days = 11; % number of days to run the simulation for
opts = odeset('MaxStep', 20);
x0 = SSdata1;
x_p0 = zeros(size(SSdata1));
t0 = 0;
tf = days*1440; %+ pars1.tchange;%1*1440 + pars1.tchange;
tspan = t0:0.5:tf;


disp('start simulation 1')
%[x0,x_p0] = decic(@(t,x,x_p) k_reg_mod(t,x,x_p, pars1, ...
%                                'Kin_type', {Kin1.Kin_type, Kin1.Meal, Kin1.KCL}, ...
%                                'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B],...
%                                'do_FF', [do_FF, pars1.FF]), ...
%                tspan, x0, [], x_p0, [], opts);
disp('decic done')
[T1,X1] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars1, ...
                                'Kin_type', {Kin1.Kin_type, Kin1.Meal, Kin1.KCL}, ...
                                'alt_sim', alt_sim1, ...
                                'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B],...
                                'do_FF', [do_FF, pars1.FF],...
                                'MealInfo', {MealInfo1.t_breakfast, MealInfo1.t_lunch, MealInfo1.t_dinner,...
                                                        MealInfo1.K_amount, MealInfo1.meal_type}), ...
                            tspan, x0, x_p0, opts);
disp('simulation 1 finished')

%% simulation 2
disp('get sim 2 SS')
pars2 = set_params();
% pars2.Phi_dtKsec_eq= 0.035;%0.03;%0.025;  % bigger ~ slightly bigger Urine [K], significantly smaller plasma [K]
% pars2.Phi_cdKsec_eq= 0.006;%0.01;   % bigger ~ slightly smaller Urine [K], significantly smaller plasma [K]
                                    % smaller ~ significantly bigger plasma [K], not much effect on urine

% pars2.cdKsec_A = 0.2; %0.161275;  - plasma
% pars2.cdKsec_B = 0.5; %0.410711;  - plasma
% 
% pars2.dtKsec_A = 0.5;%0.3475;   - plasma; vertical stretch of urinary
% pars2.dtKsec_B =  0.1; %0.23792; - plasma; vertical stretch of urinary, very small shift in the initial point


Kin2.Kin_type = 'long_simulation';%'gut_Kin';%'Preston_SS';
Kin2.Meal = 1;
Kin2.KCL = 1;

MealInfo2.t_breakfast = 7; % enter the hour at which to have breakfast in 24 hour format: for ex: 0 = midnight, 8 = 8am, 15 = 3pm
MealInfo2.t_lunch = 13;    % break between mealtimes has to be more than 6 hours for the C_insulin function to work properly
MealInfo2.t_dinner = 19;
MealInfo2.K_amount = 120/3;
MealInfo2.meal_type = 'Figure 3';


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

%% plot simulation
do_plt = 1;
if do_plt
    clear params T X
    disp('**plotting simulation results**')
    Kin_opts{1} = Kin1;
    Kin_opts{2} = Kin2;
    MealInfo{1} = MealInfo1;
    MealInfo{2} = MealInfo2;
    params{1} = pars1;
    params{2} = pars2;
    T{1} = T1;
    T{2} = T2;
    X{1} = X1;
    X{2} = X2;
    labels{1} = 'no muscle-kidney crosstalk';  % sim 1
    labels{2} = 'DT K^+ secretion crosstalk';    % sim 2
    plot_fig3_sim(T,X, params, Kin_opts, labels, tf, MealInfo, days)

    % MKplasma, MKmuscle, MKinterstitial, MKgut -- this part double checks
    % that the K doesn't magically disappear
%     delta_t1 = T1(3)-T1(2);
%     delta_t2 = T2(3)-T2(2);
% 
%     total_Kin1 = 120*7 + 400*4;
%     total_Kin2 = 120*7 + 400*4;
% 
%     delta_Kplasma1 = X1(length(T1),2) - SSdata1(2); %X1(1,2);
%     delta_Kmuscle1 = X1(length(T1),4) - SSdata1(4); %X1(1,4);
%     delta_Kinter1 = X1(length(T1),3) - SSdata1(3); %X1(1,3);
%     delta_Kgut1 = X1(length(T1),1) - SSdata1(1); %X1(1,2);
%     total_uk1 = delta_t1*sum(X1(:,28));
%     delta_amounts1 = delta_Kplasma1 + delta_Kmuscle1 + delta_Kinter1 + delta_Kgut1;
%     excreted1 = total_Kin1*0.1 + total_uk1;
%     KChange1 = delta_amounts1 + excreted1;
%     fprintf('intake 1 = %f \n', total_Kin1)
%     fprintf('delta amounts = %f \n', delta_amounts1)
%     fprintf('total change = %f \n', KChange1)
% 
%     delta_Kplasma2 = X2(length(T1),2) - SSdata2(2); %X2(1,2);
%     delta_Kmuscle2 = X2(length(T1),4) - SSdata2(4); %X2(1,4);
%     delta_Kinter2 = X2(length(T1),3) - SSdata2(3); %X2(1,3);
%     delta_Kgut2 = X2(length(T1),1) - SSdata2(1); %X2(1,1);
%     total_uk2 = delta_t2*sum(X2(:,28));
%     delta_amounts2 = delta_Kplasma2 + delta_Kmuscle2 + delta_Kinter2 + delta_Kgut2;
%     excreted2 = total_Kin2*0.1 + total_uk2;
%     KChange2 = delta_amounts2 + excreted2;
%     fprintf('intake 2 = %f \n', total_Kin2)
%     fprintf('delta amounts X on = %f \n', delta_amounts2)
%     fprintf('total change X on = %f \n', KChange2)

end
