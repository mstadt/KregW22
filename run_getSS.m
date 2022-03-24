% runs the getSS function using given input

%% Begin user input
pars = set_params();

% trying fitted params
pars.Phi_dtKsec_eq= 0.041;%0.043;%0.0427;%0.043;
pars.Phi_cdKsec_eq= 0.0022;%0.0018;%0.002;%0.002;

pars.FF = 0.250274;   
pars.insulin_A = 1;%0.999045;
pars.insulin_B = 0.6753 ; %0.6645 makes rho ins 1;%
pars.cdKreab_A = 0.295650;
pars.cdKreab_B = 0.472825;
pars.Kec_total = 4.2;


Kin.Kin_type = 'gut_Kin3';
Kin.Meal = 1;
Kin.KCL  = 0;
MKX = 0; %MK crosstalk
urine = true;

alt_sim = true; %false; % run an alternative simulation (if set up)
if alt_sim
    disp('******doing alt_sim**********')
end

IG_dir = './IGData/';
if MKX
    IG_fname = 'KregSS_MK.mat';
else
    IG_fname = 'KregSS.mat';
end

%% end user input

IG_file = append(IG_dir, IG_fname);
[SSdata, exitflag, residual] = getSS(IG_file, pars, Kin,...
                                'alt_sim', alt_sim, ...
                                'do_M_K_crosstalk', [MKX, 0.1], ...
                                'urine',urine);
if exitflag <=0
    disp(residual)
end
disp_SSdata = 1; % set of 0 if don't want all variable output printed
if disp_SSdata
    for ii = 1:length(SSdata)
        if ii <= size(pars.varnames, 2)
            fprintf('%s %.5f \n', pars.varnames{ii}, SSdata(ii))
        else
            fprintf('extra var %.5f \n', SSdata(ii))
        end %if
    end %for
end %if

% kidney function check
% phi_uk = 0.1*SSdata(23) + SSdata(26) + SSdata(31) - SSdata(34);
% fprintf('phiuk baseline: %f \n', phi_uk)
% fprintf('want phiuk = %f \n', 0.9*pars.Phi_Kin_ss);

save_file = input('save file? (0/1)  ');
%save_file = 0;
if save_file
    save_name = input('File to save IG: ');
    save_name = append(IG_dir, save_name);
    IG = SSdata;
    params = pars;
    save(save_name, 'IG', 'params')
end %if save_file
