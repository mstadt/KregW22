tpoints = [0, 89.5, 270];
rhopoints = [1.0, 1.085, 1.0];

xdata = tpoints;
ydata = rhopoints;
lb = [0, 0];
ub = [inf, Inf];

x0 = [0.1,1.0];
[x1, resnorm1] = lsqcurvefit(@fit_fun, x0, xdata, ydata, lb, ub);
params1 = x1;

fprintf('A_insulin = %f \n', params1(1))
fprintf('B_insulin = %f \n', params1(2))

pars = set_params();
ins_A = params1(1);
ins_B = params1(2);

t_ins_vals = 0:0.5:500;

Cins_vals = zeros(size(t_ins_vals));

for ii = 1:length(t_ins_vals)
    Cins_vals(ii) = get_Cinsulin(t_ins_vals(ii));
end

figure(1)
plot(t_ins_vals, Cins_vals, 'linewidth', 1.5)
xlabel('t_{insulin} (mins)')
ylabel('C_{insulin}/100 (\mu U/mL)')

Cins_max = max(Cins_vals);
Cins_min = min(Cins_vals);

Cin_vals2 = Cins_min:0.01:Cins_max;
rho_ins = zeros(size(Cin_vals2));

for ii = 1:length(rho_ins)
    rho_ins(ii) = get_rhoins(Cin_vals2(ii), ins_A, ins_B);
end

figure(2)
plot(Cin_vals2, rho_ins, 'linewidth', 1.5)
xlabel('C_{insulin}/100 (\mu U/mL)')
ylabel('\rho_{insulin}')

% t_insulin versus rho_insulin
rho_ins2 = zeros(size(t_ins_vals));

for ii = 1:length(rho_ins2)
    Cins = get_Cinsulin(t_ins_vals(ii));
    rho_ins2(ii) = get_rhoins(Cins, ins_A, ins_B);
end

figure(3)
plot(t_ins_vals, rho_ins2, 'linewidth', 1.5)
xlabel('t_{insulin} (mins)')
ylabel('\rho_{insulin}')

% steady state rho_insulin
SS = 1;
t = 0;
Kin.Kin_type = 'gut_Kin'; % 'step_Kin2';
Kin.Meal     = 0;
Kin.KCL      = 0;
[Phi_Kin_ss, t_insulin_ss] = get_PhiKin(t, SS, pars, Kin);
Cins_ss = get_Cinsulin(t_insulin_ss);
rhoins_ss = get_rhoins(Cins_ss, ins_A, ins_B);
fprintf('Cins_ss = %f \n', Cins_ss)
fprintf('rho_insulin_ss = %f \n', rhoins_ss)

function rhoins = fit_fun(p, t_ins_data)
    Cins_data = zeros(size(t_ins_data));
    for ii = 1:length(t_ins_data)
        Cins_data(ii) = get_Cinsulin(t_ins_data(ii));
    end
    rhoins = get_rhoins(Cins_data, p(1), p(2));
end
