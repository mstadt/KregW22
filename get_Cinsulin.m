function C_insulin = get_Cinsulin(t_insulin)
    % C_insulin units are nanomole/L
    if (t_insulin <= 0)
        %    disp('between meal')
        C_insulin = 22.6/1000;
    elseif (t_insulin > 0) && (t_insulin<(1.5*60))
        %disp('start of meal')
        C_insulin = ((325 - 22.6)/(1.5*60)*(t_insulin) + 22.6)/1000;
    elseif (t_insulin >= (1.5*60)) && t_insulin<(6*60)
        %disp('end of meal')
        C_insulin = ((22.6-325)/((6-1.5)*60)*(t_insulin-6*60) + 22.6)/1000;
    elseif (t_insulin>=(6*60))
        C_insulin = 22.6/1000;
    else
        disp('something weird happened')
        disp(t_insulin)
    end
end % get_C_insulin


% function C_ins = get_Cinsulin(t_insulin)
% % C_ins units are in mu U/mL
%     if t_insulin == 0
%         C_ins = 8.3;
%     elseif (t_insulin > 0) && (t_insulin <= 30)
%         m = (190.4 - 8.3)/30;
%         b = 8.3;
%         C_ins = m*(t_insulin) + b;
%     elseif (t_insulin > 30) && (t_insulin <= 90)
%         m = (242.7 - 190.4)/(90-30);
%         b = 190.4 - 30*m;
%         C_ins = m*(t_insulin) + b;
%     elseif (t_insulin > 90) && (t_insulin <= 270)
%         %   quadratic
%         a = (8.3 - 242.7)/(270-90)^2;
%         h = 90;
%         k = 242.7;
%         C_ins = a*(t_insulin-h).^2 + k;
%         
%         % line
% %         m = -(242.7 - 8.3)/(270 - 90);
% %         b = 8.3 - m*270;
% %         C_ins = m*(t_insulin) + b;
%     elseif t_insulin > 270
%         C_ins = 8.1;
%     end
%     C_ins = C_ins/100;
% end %get_C_insulin