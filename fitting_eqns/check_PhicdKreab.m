PhidtK_vals = 0.05:0.005:0.136;
%PhidtK_vals = 0:0.0005:0.5;

cdKreab_A = 0.0057;
cdKreab_B = 0.0068508;
cdKreab_params = [cdKreab_A, cdKreab_B];
cdKreab_vals = getPhicdKreab(PhidtK_vals, cdKreab_params);

figure(27)
plot(PhidtK_vals, cdKreab_vals, 'linewidth', 1.5)
xlabel('\Phi_{dtK}')
ylabel('\Phi_{cdKreab}')

dtK_ss = 0.06908;
cdKreab_ss = getPhicdKreab(dtK_ss, cdKreab_params);
fprintf('SS Phi_cdKreab = %f \n', cdKreab_ss)

new_A = 0.0005;
new_B = 0.0068;
cdK_new = getPhicdKreab(dtK_ss, [new_A, new_B]);
fprintf('new cdK value = %f \n', cdK_new)

function Phi_cdKreab = getPhicdKreab(Phi_dtK, params)
    cdKreab_A = params(1);
    cdKreab_B = params(2);
    temp = (1./(1+exp(cdKreab_A.*(Phi_dtK-cdKreab_B))));
    Phi_cdKreab = Phi_dtK.*temp;
end