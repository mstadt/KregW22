function [Phi_Kin, t_insulin] = get_PhiKin(t, SS, pars, Kin)
    % returns Phi_Kin and t_insulin values based on inputs
    if SS
        % steady state values
        t_insulin = pars.t_insulin_ss;
        Phi_Kin = pars.Phi_Kin_ss;
    elseif ~SS
        if strcmp(Kin.Kin_type, 'Preston_SS')
            dec_shift = 100;
            if t<=pars.tchange
                Phi_Kin = pars.Phi_Kin_ss;
                t_insulin = pars.t_insulin_ss;
            elseif t<= pars.tchange + dec_shift
                % linear decreased down to 60/1440
                temp = 100/1440 - 60/1440;
                m = temp/100;
                Phi_Kin = -m*(t-pars.tchange) + 100/1440;
                t_insulin = pars.t_insulin_ss + (t - pars.tchange);
            else 
                Phi_Kin = 60/1440;
                t_insulin = pars.t_insulin_ss + (t-pars.tchange);
            end
        else
            fast_start = pars.tchange + 60;
            exp_start = fast_start + 6*60; 
            if t <= pars.tchange
                Phi_Kin = pars.Phi_Kin_ss;
                t_insulin = pars.t_insulin_ss;
            elseif t<=fast_start
                %first linear decrease to 0
                %Phi_Kin = max(0,-pars.Phi_Kin_ss/120*(t-pars.tchange) + pars.Phi_Kin_ss);
                Phi_Kin = max(0, -pars.Phi_Kin_ss/30*(t-pars.tchange)+pars.Phi_Kin_ss);
                t_insulin = pars.t_insulin_ss + (t - pars.tchange);
            elseif t <= exp_start
                Phi_Kin = 0;
                t_insulin = 0;
            %% experiment starts
            elseif strcmp(Kin.Kin_type, 'gut_Kin')
                t1 = exp_start + 15;
                t2 = t1 + 15;
                if t<= t1
                    h = 35/15;
                    m = (h)/15;
                    Phi_Kin = Kin.KCL*(m*(t-exp_start));
                    t_insulin = Kin.Meal*(t-exp_start);
                elseif t<= t2
                    h = 35/15;
                    m = -h/15;
                    b = -m*30;
                    Phi_Kin = Kin.KCL*(m*(t-exp_start) + b);
                    t_insulin = Kin.Meal*(t-exp_start);
                elseif t>t2
                    Phi_Kin = Kin.KCL*0;
                    t_insulin = Kin.Meal*(t-exp_start);
                end
            elseif strcmp(Kin.Kin_type, 'gut_Kin2')
                t1 = exp_start + 10;
                t2 = t1 + 10;
                t3 = t2 + 10;
                if t<= t1
                    h = 1.5;
                    m = h/10;
                    Phi_Kin = Kin.KCL*(m*(t-exp_start));
                    t_insulin = Kin.Meal*(t-exp_start);
                elseif t<= t2
                    Phi_Kin = 1.5;
                    t_insulin = Kin.Meal*(t-exp_start);
                elseif t<= t3
                    h = 1.5;
                    m = -h/10;
                    b = -m*30;
                    Phi_Kin = Kin.KCL*(m*(t-exp_start)+b);
                    t_insulin = Kin.Meal*(t-exp_start);
                elseif t>t3
                    Phi_Kin = Kin.KCL*0;
                    t_insulin = Kin.Meal*(t-exp_start);
                end
            else
                fprintf('What is this? Kin_type: %s', Kin.Kin_type)
            end %step_Kin
        end % if Preston_60
    end %if SS

end %get_PhiKin