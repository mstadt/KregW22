function gamKin = getFF(M_Kgut, FF_A, pars)
    gamKin = FF_A*(M_Kgut - 0.9*pars.MKgutSS) + 1;
end