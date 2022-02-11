function [dMKgut,M_Kmuscle_p,time_out] = get_dMKgut_dt(Phi_Kin, k_gut, M_Kgut, Phi_ECtoIC, Phi_ICtoEC,time_in)
    %returns the dM_Kgut based on inputs
    dMKgut = 0.9*Phi_Kin-k_gut*M_Kgut;
    time_out=time_in;

    M_Kmuscle_p = (Phi_ECtoIC - Phi_ICtoEC);

    % in the k_reg_mod: f(10) = Phi_ECtoIC ...  
    %                   f(11) = Phi_ICtoEC ...

end