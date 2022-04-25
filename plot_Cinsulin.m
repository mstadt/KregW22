function plot_Cinsulin()
% plots C insulin over one day of experiment. (in the simulation, get_Cinsulin works properly 
% over longer periods of time, more than one day. This plot_Cinsulin function was created to 
% test whether get_Cinsulin works properly over the period of just one day)

close all
t_start = 0;
t_end = 1440;
MealInfo.t_breakfast = 7;
MealInfo.t_lunch = 13;
MealInfo.t_dinner = 19;

% fontsizes
fonts.title = 15;
fonts.xlabel = 15;
fonts.ylabel = 15;
fonts.legend = 15;

marker_size = 15;
labels{1} = 'C insulin vs time (mins)';
labels{2} = '\rho insulin vs time (mins)';
labels{3} = '\rho inslulin vs C insulin';

pars1 = set_params();
params{1}=pars1;
Kin1.Kin_type = 'long_simulation'; 
Kin1.Meal = 0;
Kin1.KCL = 1;
Kin2.Kin_type = 'gut_Kin';%'Preston_SS';
Kin2.Meal = 0;
Kin2.KCL = 1;
Kin_opts{1} = Kin1;
Kin_opts{2} = Kin2;

do_ins = 0;
do_FF = 1;
col = [0.3010, 0.7450, 0.9330]; %blue

IG_file1 = './IGdata/KregSS.mat';
[SSdata1, exitflag1, residual1] = getSS(IG_file1, pars1, Kin1, ...
                                            'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B],...
                                           'do_FF', [do_FF, pars1.FF]);
opts = odeset('MaxStep', 20);

x0 = SSdata1;
x_p0 = zeros(size(SSdata1));
days = 5;
t0 = 0;
tf = days*1440 + pars1.tchange;%1*1440 + pars1.tchange;
tspan = t0:0.5:tf;

[T1,X1] = ode15i(@(t,x,x_p) k_reg_mod(t,x,x_p, pars1, ...
                                'Kin_type', {Kin1.Kin_type, Kin1.Meal, Kin1.KCL}, ...
                                'do_insulin', [do_ins, pars1.insulin_A, pars1.insulin_B],...
                                'do_FF', [do_FF, pars1.FF]), ...
                        tspan, x0, x_p0, opts);
T{1}=T1;

times1 = (T{1}-t_start)/1;

Cinsulin_vals1 = zeros(size(T{1}));
phoins_vals1=zeros(size(T{1}));

for ii = 1:length(T{1})
    [Cinsulin_vals1(ii)] = get_Cinsulin(T{1}(ii), MealInfo, Kin1);
    [phoins_vals1(ii)] = get_rhoins(Cinsulin_vals1(ii),pars1.insulin_A,pars1.insulin_B);
end % for ii

figure(1)
plot(times1, Cinsulin_vals1, 'linewidth', 2, 'color', col)
xlabel('time (mins)', 'fontsize', fonts.xlabel)
ylabel('$C_{insulin}$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
title('$C_{insulin}$ vs ($t_{insulin}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
legend(labels{1}, 'fontsize', fonts.legend)
xlim([t_start, t_end])

figure(2)
plot(times1, phoins_vals1, 'linewidth', 2, 'color', col)
xlabel('time (mins)', 'fontsize', fonts.xlabel)
ylabel('$\rho_{insulin}$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
title('$\rho_{insulin}$ vs ($t_{insulin}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
legend(labels{2}, 'fontsize', fonts.legend)
xlim([t_start, t_end])

figure(3)
plot(Cinsulin_vals1, phoins_vals1, 'linewidth', 2, 'color', col)
xlabel('C_{insulin}', 'fontsize', fonts.xlabel)
ylabel('$\rho_{insulin}$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
title('$\rho_{insulin}$ vs $C_{insulin}$', 'interpreter', 'latex', 'fontsize', fonts.title)
legend(labels{3}, 'fontsize', fonts.legend)
% Cinsulin_vals1(1)
% Cinsulin_vals1(length(T{1}))
% xlim([Cinsulin_vals1(1), Cinsulin_vals1(length(T{1}))])




end %plot_Cinsulin